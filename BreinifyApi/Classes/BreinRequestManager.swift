//
// Created by Marco Recchioni on 14/03/17.
//

import Foundation


open class BreinRequestManager {

    /// singleton
    static public let sharedInstance: BreinRequestManager = {
        let instance = BreinRequestManager()

        // setup code
        instance.configure()

        return instance
    }()

    // Can't init is singleton
    private init() {
    }

    deinit {
        updateTimer?.invalidate()
        updateTimer = nil
    }

    // dictionary of UUID to jsonRequest (unixTimestamp, fullUrl, jsonString)
    var missedRequests = [String: JsonRequest]()

    // contains the unixTimestamp when the failure was detected
    var failureTime = 0.0

    // contains the expiration Duration (5 minutes in seconds)
    var expirationDuration = 5 * 60 * 60

    /// instance for processing unsent requests
    var updateTimer: Timer?

    /// contains the background interval
    var interval = 60.0

    /// contains the delimiter between each element of the structure
    let kDelimiter = "°"

    /// contains the filename for saved requests
    let kRequestFileName = "BreinifyMissedRequests"

    /// contains the full filename for save requests
    let kRequestFullFileName = "BreinifyMissedRequests.txt"

    public func configure() {
        updateTimer = Timer.scheduledTimer(timeInterval: interval,
                target: self,
                selector: #selector(sendActivityRequests),
                userInfo: nil,
                repeats: true)
    }

    @objc
    public func sendActivityRequests() {
        print("sendActivityRequests invoked")
        print("number of missed requests are: \(self.missedRequests.count)")

        if missedRequests.count > 0 {
            print("invoking new request...")
            Breinify.getConfig().getBreinEngine().getRestEngine().executeSavedRequests()
        }
    }

    public func addRequest(timeStamp: Int, fullUrl: String?, json: String?) {
        let jsonRequest = JsonRequest()
        // UUID
        let uuid = UUID().uuidString
        jsonRequest.creationTime = timeStamp
        jsonRequest.fullUrl = fullUrl
        jsonRequest.jsonBody = json

        missedRequests[uuid] = jsonRequest

        print("Adding to Queue: \(uuid)")
    }

    public func getMissedRequests() -> [String: JsonRequest] {
        return self.missedRequests
    }

    public func clearMissedRequests() {
        self.missedRequests = [String: JsonRequest]()
    }

    public func status() -> String {
        let numberOfRequests = "# :\(self.missedRequests.count)"
        return numberOfRequests
    }

    /**

        Removes an entry from the missed requests dictionary

    */
    public func removeEntry(_ key: String) {

        print("size before is: \(missedRequests.count)")
        missedRequests.removeValue(forKey: key)
        print("size after is: \(missedRequests.count)")

    }

    /**
    
        Checks if currentEntry is in time range
 
    */
    public func checkIfValid(currentEntry: JsonRequest) -> Bool {

        let creationTime = currentEntry.creationTime
        let nowTime = Int(NSDate().timeIntervalSince1970)
        let pastTime = nowTime - expirationDuration

        if creationTime! > pastTime {
            return true
        }

        return false
    }

    /**

        Save the missed requested if necessary

    */
    public func shutdown() {
        safeMissedRequests()
    }

    /**

        This method saves the missed requests to file with the following structure:

        value-creationtime; value-fullUrl; value-jsonBody

        The key can be ignored because when the missed requests will be loaded a new
        key will be generated.

    */
    public func safeMissedRequests() {

        if self.missedRequests.count > 0 {

            let fileURL = try! FileManager.default.url(for: .documentDirectory,
                            in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent(kRequestFullFileName)

            if let outputStream = OutputStream(url: fileURL, append: true) {
                outputStream.open()

                var output = ""

                for (key, jsonElement) in self.missedRequests {
                    output = output
                            + "\(jsonElement.creationTime!)"
                            + kDelimiter
                            + jsonElement.fullUrl
                            + kDelimiter
                            + jsonElement.jsonBody
                            + "\n"

                    let bytesWritten = outputStream.write(output,
                            maxLength: output.lengthOfBytes(using: .utf8))
                    if bytesWritten < 0 {
                        print("write failure")
                    }
                }

                outputStream.close()
            } else {
                print("Unable to open file")
            }
        }

        // delete file if no entries exists
        if self.missedRequests.count == 0 {

            let fileManager = FileManager.default
            let fileName = kRequestFileName
            let docDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask,
                    appropriateFor: nil, create: true)

            if let fileURL = docDirectory?.appendingPathComponent(fileName).appendingPathExtension("txt") {

                let filePathName = fileURL.path

                do {
                    try fileManager.removeItem(atPath: filePathName)
                } catch {
                    print("Could not remove file: \(filePathName)")
                }
                    
            }
        }
    }

    /**
    
        This method loads the saved requests from file. Assuming the following structure:

        value-creationtime; value-fullUrl; value-jsonBody

        For each loaded line a new key will be generated.

    */
    public func loadMissedRequests() {

        if self.missedRequests.count == 0 {

            let fileName = kRequestFileName
            let docDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                    appropriateFor: nil, create: true)

            if let fileURL = docDirectory?.appendingPathComponent(fileName).appendingPathExtension("txt") {

                // Reading back from the file
                var inString = ""
                do {
                    inString = try String(contentsOf: fileURL)
                    print(inString)

                    let fileContent = inString.components(separatedBy: .newlines)

                    for line in fileContent {
                        let elements = line.components(separatedBy: kDelimiter)

                        if elements.count >= 3 {
                            let unixTimestampAsInt: String = elements[0]
                            let unixTimestamp = Int(unixTimestampAsInt)
                            let fullUrl = elements[1]
                            let jsonBody = elements[2]

                            addRequest(timeStamp: unixTimestamp!, fullUrl: fullUrl, json: jsonBody)
                        }
                    }
                } catch {
                    print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
                }
            }
        }
    }
}
