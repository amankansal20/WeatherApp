
import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    typealias LocationClosure = ((_ location: CLLocation?,_ error: NSError?) -> Void)
    private var locationCompletionHandler: LocationClosure?
    
    private var locationManager: CLLocationManager?
    var locationAccuracy = kCLLocationAccuracyThreeKilometers
    
    var lastLocation: CLLocation?
    var userDenied: Bool = false
    
    //Singleton Instance
    static let sharedInstance = LocationManager()
    private override init() { }
    
    //MARK:- Destroy the LocationManager
    deinit {
        destroyLocationManager()
    }
    
    //MARK:- Private Methods
    private func setupLocationManager() {
        //Setting of location manager
        locationManager = nil
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = locationAccuracy
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    
    class var isLocationAvailable: Bool {
        get {
            if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                return true
            }
            return false
        }
    }
    
    private func destroyLocationManager() {
        locationManager?.delegate = nil
        locationManager = nil
        lastLocation = nil
    }
    
    func getLocation(completionHandler:@escaping LocationClosure) {
        
        //Cancelling the previous selector handlers if any
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        //Resetting last location
        lastLocation = nil
        
        self.locationCompletionHandler = completionHandler
        
        setupLocationManager()
    }
    
    //MARK:- Final closure/callback
    fileprivate func didComplete(location: CLLocation?,error: NSError?) {
        locationCompletionHandler?(location,error)
        if error == nil {
            locationManager?.stopUpdatingLocation()
            locationManager?.delegate = nil
            locationManager = nil
        }
    }
}

//MARK:- CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {return}
        self.didComplete(location: lastLocation, error: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            self.locationManager?.startUpdatingLocation()
        case .denied,.notDetermined,.restricted:
            self.didComplete(location: CLLocation(latitude: 21.1458 , longitude: 79.0882), error: nil)
        default:
            return
        }
    }
}
