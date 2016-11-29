//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation

public class BreinEngine {

    public typealias apiSuccess = (result:BreinResult?) -> Void
    public typealias apiFailure = (error:NSDictionary?) -> Void

    var restEngine: IRestEngine!

    var manager = BreinLocationManager()

    //
    public init(engineType: BreinEngineType) throws {
        switch engineType {
        case BreinEngineType.ALAMOFIRE:
            self.restEngine = AlamofireEngine()
        case BreinEngineType.NO_ENGINE:
            throw BreinError.BreinConfigurationError("no rest engine configured.")
        }
    }

    /**
     * sends an activity to the Breinify server
     *
     * @param activity data
     */
    public func sendActivity(activity: BreinActivity!,
                             success successBlock: BreinEngine.apiSuccess,
                             failure failureBlock: BreinEngine.apiFailure) throws {
        if activity != nil {

            manager.fetchWithCompletion {

                location, error in

                // save the retrieved location data
                activity.setLocationData(location)

                // print("latitude is: \(location?.coordinate.latitude)")
                // print("longitude is: \(location?.coordinate.longitude)")

                do {
                    try self.restEngine.doRequest(activity,
                            success: successBlock,
                            failure: failureBlock)
                } catch {
                    print("\(error)")
                }
            }
        }
    }

    public func performLookUp(breinLookup: BreinLookup!,
                              success successBlock: apiSuccess,
                              failure failureBlock: apiFailure) throws {
        if breinLookup != nil {
            return try restEngine.doLookup(breinLookup,
                    success: successBlock,
                    failure: failureBlock)
        }
    }

    public func performTemporalDataRequest(breinTemporalData: BreinTemporalData!,
                              success successBlock: apiSuccess,
                              failure failureBlock: apiFailure) throws {
        if breinTemporalData != nil {
            return try restEngine.doTemporalDataRequest(breinTemporalData,
                    success: successBlock,
                    failure: failureBlock)
        }
    }

    public func getRestEngine() -> IRestEngine! {
        return restEngine
    }

    public func configure(breinConfig: BreinConfig!) {
        restEngine.configure(breinConfig)
    }

    public func getUserAgent() -> String {

        let userAgent: String = {
            if let info = NSBundle.mainBundle().infoDictionary {
                let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
                let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
                let version = info[kCFBundleVersionKey as String] as? String ?? "Unknown"

                let osNameVersion: String = {
                    let versionString: String

                    if #available(OSX 10.10, *) {
                        let version = NSProcessInfo.processInfo().operatingSystemVersion
                        versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                    } else {
                        versionString = "10.9"
                    }

                    let osName: String = {
#if os(iOS)
                        return "iOS"
#elseif os(watchOS)
                        return "watchOS"
#elseif os(tvOS)
                        return "tvOS"
#elseif os(OSX)
                        return "OS X"
#elseif os(Linux)
                        return "Linux"
#else
                        return "Unknown"
#endif
                    }()

                    return "\(osName) \(versionString)"
                }()

                return "\(executable)/\(bundle) (\(version); \(osNameVersion))"
            }

            return "Breinify"
        }()


        return userAgent
    }

}