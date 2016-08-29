import UIKit
import CoreLocation

//possible errors
enum BreinLocationManagerErrors: Int {
    case AuthorizationDenied
    case AuthorizationNotDetermined
    case InvalidLocation
}

public class BreinLocationManager: NSObject, CLLocationManagerDelegate {

    public typealias LocationClosure = ((location: CLLocation?, error: NSError?) -> ())

    //location manager
    private var locationManager: CLLocationManager?

    //destroy the manager
    deinit {
        locationManager?.delegate = nil
        locationManager = nil
    }

    private var didComplete: LocationClosure?

    //location manager returned, call didcomplete closure
    private func completionHandler(location: CLLocation?, error: NSError?) {
        locationManager?.stopUpdatingLocation()
        didComplete?(location: location, error: error)
        locationManager?.delegate = nil
        locationManager = nil
    }

    //location authorization status changed
    public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        switch status {
        case .AuthorizedWhenInUse:
            self.locationManager!.startUpdatingLocation()
        case .Denied:
            completionHandler(nil, error: NSError(domain: self.classForCoder.description(),
                    code: BreinLocationManagerErrors.AuthorizationDenied.rawValue,
                    userInfo: nil))
        default:
            break
        }
    }

    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        completionHandler(nil, error: error)
    }

    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        completionHandler(location, error: nil)
    }

    //ask for location permissions, fetch 1 location, and return
    public func fetchWithCompletion(completion: LocationClosure) {
        //store the completion closure
        didComplete = completion

        //fire the location manager
        locationManager = CLLocationManager()
        locationManager!.delegate = self

        //check for description key and ask permissions
        if (NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationWhenInUseUsageDescription") != nil) {
            // locationManager!.requestWhenInUseAuthorization()
            completionHandler(nil, error: NSError(domain: "BreinLocationManager", code: 100, userInfo: nil))

        } else if (NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationAlwaysUsageDescription") != nil) {
            completionHandler(nil, error: NSError(domain: "BreinLocationManager", code: 101, userInfo: nil))
            // locationManager!.requestAlwaysAuthorization()
        }
    }
}