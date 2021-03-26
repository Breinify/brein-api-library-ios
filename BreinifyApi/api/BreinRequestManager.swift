//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation

open class BreinRequestManager {

    /// singleton
    static public let shared: BreinRequestManager = {
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
    var interval = 120.0

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
        BreinLogger.shared.log("Breinify sendActivityRequests invoked - number of missed requests are: \(missedRequests.count)")

        if missedRequests.count > 0 {
            BreinLogger.shared.log("Breinify invoking saved activity requests")
            Breinify.getConfig().getBreinEngine().getRestEngine().executeSavedRequests()
        }
    }

    public func addMissedRequest(timeStamp: Int, fullUrl: String?, json: String?) {
        let jsonRequest = JsonRequest()
        let uuid = UUID().uuidString

        jsonRequest.creationTime = timeStamp
        jsonRequest.fullUrl = fullUrl
        jsonRequest.jsonBody = json

        missedRequests[uuid] = jsonRequest

        BreinLogger.shared.log("Breinify adding to queue: \(uuid)")
    }

    public func getMissedRequests() -> [String: JsonRequest] {
        missedRequests
    }

    public func clearMissedRequests() {
        missedRequests = [String: JsonRequest]()
    }

    public func status() -> String {
        let numberOfRequests = "# :\(missedRequests.count)"
        return numberOfRequests
    }

    /**

        Removes an entry from the missed requests dictionary

    */
    public func removeEntry(_ key: String) {
        BreinLogger.shared.log("Breinify size before removeEntry is: \(missedRequests.count)")
        missedRequests.removeValue(forKey: key)
        BreinLogger.shared.log("Breinify size after removeEntry is: \(missedRequests.count)")
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
        // deactivated now
        // safeMissedRequests()
    }

    /**

        This method saves the missed requests to file with the following structure:

        value-creationtime; value-fullUrl; value-jsonBody

        The key can be ignored because when the missed requests will be loaded a new
        key will be generated.

    */
    public func safeMissedRequests() {

        if missedRequests.count > 0 {
            let fileURL = try! FileManager.default.url(for: .documentDirectory,
                            in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent(kRequestFullFileName)

            if let outputStream = OutputStream(url: fileURL, append: true) {
                outputStream.open()

                var output = ""

                for (_, jsonElement) in missedRequests {
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
                        BreinLogger.shared.log("Breinify write failure in safeMissedRequests")
                    }
                }

                outputStream.close()
            } else {
                BreinLogger.shared.log("Breinify unable to open file in safeMissedRequests")
            }
        }

        // delete file if no entries exists
        if missedRequests.count == 0 {

            let fileManager = FileManager.default
            let fileName = kRequestFileName
            let docDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask,
                    appropriateFor: nil, create: true)

            if let fileURL = docDirectory?.appendingPathComponent(fileName).appendingPathExtension("txt") {

                let filePathName = fileURL.path

                do {
                    try fileManager.removeItem(atPath: filePathName)
                } catch {
                    BreinLogger.shared.log("Breinify safeMissedRequests - could not remove file: \(filePathName)")
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

        if missedRequests.count == 0 {

            let fileName = kRequestFileName
            let docDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                    appropriateFor: nil, create: true)

            if let fileURL = docDirectory?.appendingPathComponent(fileName).appendingPathExtension("txt") {

                // Reading back from the file
                var inString = ""
                do {
                    inString = try String(contentsOf: fileURL)
                    BreinLogger.shared.log("Breinify loadMissedRequests - line is: \(inString)")

                    let fileContent = inString.components(separatedBy: .newlines)

                    for line in fileContent {
                        let elements = line.components(separatedBy: kDelimiter)

                        if elements.count >= 3 {
                            let unixTimestampAsInt: String = elements[0]
                            let unixTimestamp = Int(unixTimestampAsInt)
                            let fullUrl = elements[1]
                            let jsonBody = elements[2]

                            addMissedRequest(timeStamp: unixTimestamp!, fullUrl: fullUrl, json: jsonBody)
                        }
                    }
                } catch {
                    BreinLogger.shared.log("Breinify loadMissedRequests - failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
                }
            }
        }
    }
}
