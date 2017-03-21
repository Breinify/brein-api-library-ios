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
    
    // dictionary of unixTimestamp + jsonRequest (unixTimestamp, fullUrl, jsonString)
    var missedRequests = [JsonRequest]()

    // contains the unixTimestamp when the failure was detected
    var failureTime = 0.0

    // contains the expiration Duration (5 minutes)
    var expirationDuration = 5 * 60

    var updateTimer: Timer?

    var interval = 10.0

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

        if  missedRequests.count > 0 {
            print("invoking new request...")
            Breinify.getConfig().getBreinEngine().getRestEngine().executeSavedRequests()
        }
    }

    public func addRequest(timeStamp: Int, fullUrl: String?, json: String?) {
        let jsonRequest = JsonRequest()
        jsonRequest.creationTime = timeStamp
        jsonRequest.fullUrl = fullUrl
        jsonRequest.jsonBody = json

        missedRequests.append(jsonRequest)
    }

    public func getMissedRequestArray() -> [JsonRequest] {
        return self.missedRequests
    }

    public func clearMissedRequests() {
        self.missedRequests = [JsonRequest]()
    }

    public func status() -> String {
        let numberOfRequests = "# :\(self.missedRequests.count)"
        return numberOfRequests
    }

    public func shutdown() {
        safeMissedRequests()
    }

    public func safeMissedRequests() {
        if self.missedRequests.count > 0 {

            let fileURL = try! FileManager.default.url(for: .documentDirectory,
                            in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("BreinifyMissedRequests.txt")

            if let outputStream = OutputStream(url: fileURL, append: true) {
                outputStream.open()

                var output = ""
                for jsonElement in self.missedRequests {
                    output = output
                            + "\(jsonElement.creationTime)"
                            + ";"
                            + jsonElement.fullUrl
                            + ";"
                            + jsonElement.jsonBody
                            + "\n"
                }
                let bytesWritten = outputStream.write(output,
                        maxLength: output.lengthOfBytes(using: .utf8))
                if bytesWritten < 0 {
                    print("write failure")
                }
                outputStream.close()
            } else {
                print("Unable to open file")
            }
        }
    }

    public func loadMissedRequests() {

        if self.missedRequests.count == 0 {

            let fileName = "BreinifyMissedRequests"
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
                        let element = line.components(separatedBy: ";")

                        if element.count >= 3 {
                            print(element)
                            let unixTimestamp = Int(element[0])!
                            let fullUrl = element[1]
                            let jsonBody = element[2]

                            addRequest(timeStamp: unixTimestamp, fullUrl: fullUrl, json: jsonBody)
                        }
                    }
                } catch {
                    print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
                }
            }
        }
    }
}
