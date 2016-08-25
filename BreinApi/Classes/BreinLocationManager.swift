import UIKit
import CoreLocation

//possible errors
enum BreinLocationManagerErrors: Int {
    case AuthorizationDenied
    case AuthorizationNotDetermined
    case InvalidLocation
}

public class BreinLocationManager: NSObject, CLLocationManagerDelegate {

    //location manager
    private var locationManager: CLLocationManager?

    //destroy the manager
    deinit {
        locationManager?.delegate = nil
        locationManager = nil
    }

    typealias LocationClosure = ((location: CLLocation?, error: NSError?)->())
    private var didComplete: LocationClosure?

    //location manager returned, call didcomplete closure
    private func _didComplete(location: CLLocation?, error: NSError?) {
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
            _didComplete(nil, error: NSError(domain: self.classForCoder.description(),
                    code: BreinLocationManagerErrors.AuthorizationDenied.rawValue,
                    userInfo: nil))
        default:
            break
        }
    }

    public func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        _didComplete(nil, error: error)
    }

    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        _didComplete(location, error: nil)
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
        }

    }
}