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
  In order to enable this the App needs to have the appropriate permissions.

  The file: info.plist of your App needs to have the following content:

    <key>NSLocationWhenInUseUsageDescription</key>
	<string>Please allow this app to provide location data.</string>

	<key>NSLocationAlwaysUsageDescription</key>
	<string>Please allow this app to provide location data.</string>


    Some information regarding accuracy:
    * in case of "flight mode" -> only devices GPS is available and the
      accuracy needs to be set to kCLLocationAccuracyKilometer
    * otherwise it will be set to -> kCLLocationAccuracyBest

	- kCLLocationAccuracyBestForNavigation –
	           Uses the highest possible level of accuracy augmented by additional sensor data.
	           This accuracy level is intended solely for use when the device is connected to an external power supply.
    - kCLLocationAccuracyBest –
               The highest recommended level of accuracy for devices running on battery power.
    - kCLLocationAccuracyNearestTenMeters -
               Accurate to within 10 meters.
    - kCLLocationAccuracyHundredMeters –
               Accurate to within 100 meters.
    - kCLLocationAccuracyKilometer –
               Accurate to within one kilometer.
    - kCLLocationAccuracyThreeKilometers –
                Accurate to within three kilometers.


	    
*/

public class BreinLocationManager: NSObject, CLLocationManagerDelegate {

    // handy typealias
    public typealias LocationClosure = ((_ location: CLLocation?, _ error: NSError?) -> ())

    // location manager
    private var locationManager = CLLocationManager()

    // destroy the manager
    deinit {
        locationManager.delegate = nil
        // locationManager = nil
    }

    // completion closure
    private var didComplete: LocationClosure?

    // in case of failure or ignore return 0,0
    private let dummyLocation = CLLocation(latitude: 0, longitude: 0)

    // default => do not ignore
    private var ignoreLocationRequestState = false
    
    /// 
    public override init() {
        super.init()
        self.ignoreLocationRequestState = false
    }

    // ctor with option to ignore request
    public init(ignoreLocationRequest: Bool) {
        super.init()
        self.ignoreLocationRequestState = ignoreLocationRequest
    }

    // ignore request
    public func ignoreLocationRequest() -> Bool {
        return self.ignoreLocationRequestState
    }

    // ignore request
    public func setIgnoreLocationRequest(ignoreLocationRequest: Bool) -> BreinLocationManager {
        self.ignoreLocationRequestState = ignoreLocationRequest
        return self
    }

    // location manager returned, call closure
    private func completionHandler(location: CLLocation?, error: NSError?) {

        locationManager.stopUpdatingLocation()
        didComplete?(location, error)
        locationManager.delegate = nil
    }

    /// location authorization status changed
    @nonobjc
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        switch status {
        case .authorizedWhenInUse,
             .authorizedAlways,
             .notDetermined:
            self.locationManager.startUpdatingLocation()

        default:
            completionHandler(location: dummyLocation, error: NSError(domain: self.classForCoder.description(),
                    code: BreinLocationManagerErrors.AuthorizationDenied.rawValue,
                    userInfo: nil))
        }
    }

    // invoked in case of a failure
    @nonobjc
    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        completionHandler(location: dummyLocation, error: error)
    }

    // invoked in case of a valid location
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let noError = NSError(domain: "BreinLocationManager", code: 200, userInfo: nil)
        completionHandler(location: location, error: noError)
    }

    /**
    This method checks if the app has the authorization to invoke the
    calls:
        - CLLocationManager().requestWhenInUseAuthorization()
        - CLLocationManager().requestAlwaysAuthorization()

    If this is the case then the appropriate calls will be invoked.
    Otherwise a callback to exit will be invoked.

    */
    public func fetchWithCompletion(_ completion: @escaping LocationClosure) {

        //store the completion closure
        didComplete = completion

        // check if location request should be ignored
        if self.ignoreLocationRequest() == true {
            completionHandler(location: dummyLocation, error: NSError(domain: "BreinLocationManager", code: 103, userInfo: nil))
        }

        // fire the location manager
        locationManager.delegate = self
        
        // depending of network connection choose accuracy
        // remark:
        // in flightMode only kCLLocationAccuracyKilometer will only work
        //
        let networkConnected = BreinReachability.connectedToNetwork()
        if networkConnected == true {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            // setting to Kilometer is the only chance to use the GPS module without
            // being connected to the internet
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        }
        
        // let whenInUseUsage = Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription")
        // let alwaysUsage = Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription")

        // indicates if the callback should be completed
        locationManager.requestAlwaysAuthorization()
        // when in use foreground
        locationManager.requestWhenInUseAuthorization()

        // try it..
        locationManager.startUpdatingLocation()

        let status = CLLocationManager.authorizationStatus()
        if status == .restricted
                   || status == .denied {
            // return with dummy location object
            completionHandler(location: dummyLocation, error: NSError(domain: "BreinLocationManager", code: 102, userInfo: nil))
        }
        
    }
}
