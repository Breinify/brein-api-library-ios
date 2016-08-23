import UIKit
import CoreLocation

//possible errors

enum LocationManagerErrors: Int {
    case AuthorizationDenied
    case AuthorizationNotDetermined
    case InvalidLocation
}

class LocationManager: NSObject, CLLocationManagerDelegate {

    typealias LocationClosure = ((location:CLLocation?, error:NSError?) -> ())

    //location manager
    private var locationManager: CLLocationManager?

    private var didComplete: LocationClosure?

    //destroy the manager
    deinit {
        locationManager?.delegate = nil
        locationManager = nil
    }

    //location manager returned, call didcomplete closure
    private func _didComplete(location: CLLocation?, error: NSError?) {
        locationManager?.stopUpdatingLocation()
        didComplete?(location: location, error: error)
        locationManager?.delegate = nil
        locationManager = nil
    }

    internal func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        _didComplete(nil, error: error)
    }

    internal func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        _didComplete(location, error: nil)
    }

    //location authorization status changed
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        switch status {
        case .AuthorizedWhenInUse:
            self.locationManager!.startUpdatingLocation()
        case .Denied:
            _didComplete(nil, error: NSError(domain: self.classForCoder.description(),
                    code: LocationManagerErrors.AuthorizationDenied.rawValue,
                    userInfo: nil))
        default:
            break
        }
    }

    //ask for location permissions, fetch 1 location, and return
    func fetchWithCompletion(completion: LocationClosure) {
        //store the completion closure
        didComplete = completion

        //fire the location manager
        locationManager = CLLocationManager()
        locationManager!.delegate = self

        //check for description key and ask permissions
        if (NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationWhenInUseUsageDescription") != nil) {
            locationManager!.requestWhenInUseAuthorization()
        } else if (NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationAlwaysUsageDescription") != nil) {
            locationManager!.requestAlwaysAuthorization()
        } else {
            fatalError("To use location in iOS you need to define either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription in the app bundle's Info.plist file")
        }

        // locationManager!.startUpdatingLocation()
    }
}
