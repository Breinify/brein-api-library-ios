//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import UIKit
import CoreLocation

// possible errors
enum BreinLocationManagerErrors: Int {
    case AuthorizationDenied
    case AuthorizationNotDetermined
    case InvalidLocation
}

/**
  This class tries to receive the location information.
  In order to do this the App needs to have the appropriate permissions.

  The file: info.plist needs to have the following entry:

     <key>NSLocationWhenInUseUsageDescription</key>
     <string>Give us permission to use your device's location</string>

*/
public class BreinLocationManager: NSObject, CLLocationManagerDelegate {

    public typealias LocationClosure = ((location:CLLocation?, error:NSError?) -> ())

    // location manager
    private var locationManager: CLLocationManager?

    // destroy the manager
    deinit {
        locationManager?.delegate = nil
        locationManager = nil
    }

    private var didComplete: LocationClosure?

    private let dummyLocation = CLLocation(latitude: 0, longitude: 0)

    // location manager returned, call closure
    private func completionHandler(location: CLLocation?, error: NSError?) {

        locationManager?.stopUpdatingLocation()
        didComplete?(location: location, error: error)
        locationManager?.delegate = nil
        locationManager = nil
    }

    //location authorization status changed
    public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        switch status {
            case .AuthorizedWhenInUse, .AuthorizedAlways:
            self.locationManager!.startUpdatingLocation()
        case .Denied:
            completionHandler(dummyLocation, error: NSError(domain: self.classForCoder.description(),
                    code: BreinLocationManagerErrors.AuthorizationDenied.rawValue,
                    userInfo: nil))
        default:
            break
        }
    }

    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        completionHandler(dummyLocation, error: error)
    }

    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let noError = NSError(domain: "BreinLocationManager", code: 200, userInfo: nil)
        completionHandler(location, error: noError)
    }

    /**
    This method checks if the app has the authorization to invoke the
    calls:
        - CLLocationManager().requestWhenInUseAuthorization()
        - CLLocationManager().requestAlwaysAuthorization()

    If this is the case then the appropriate calls will be invoked.
    Otherwise a callback to exit will be invoked.

    */
    public func fetchWithCompletion(completion: LocationClosure) {
        //store the completion closure
        didComplete = completion

        //fire the location manager
        locationManager = CLLocationManager()
        locationManager!.delegate = self

        let status = CLLocationManager.authorizationStatus()

        let whenInUseUsage = NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationWhenInUseUsageDescription")
        let alwaysUsage = NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationAlwaysUsageDescription")

        // indicates if the callback should be completed
        var invokeCompletionHandler = true
        if (whenInUseUsage != nil) {
            if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
                invokeCompletionHandler = false
                // this needs to be invoked in order to receive the updates
                locationManager!.requestWhenInUseAuthorization()
            }
        } else if (alwaysUsage != nil) {
            if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
                invokeCompletionHandler = false
                // this needs to be invoked
                locationManager!.requestAlwaysAuthorization()
            }
        }

        if invokeCompletionHandler == true {
            completionHandler(dummyLocation, error: NSError(domain: "BreinLocationManager", code: 102, userInfo: nil))
        }

    }
}