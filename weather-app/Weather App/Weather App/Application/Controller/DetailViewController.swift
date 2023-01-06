import UIKit
import CoreLocation

class DetailViewController: UIViewController{
    var forecastModel: ForecastModelElement?
    var cityName: String?
    @IBOutlet weak var iconPhrase: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var choosenCity: UILabel!
    @IBOutlet weak var precipitationProbability: UILabel!
    @IBOutlet weak var weatherTypeImage: UIImageView!
    @IBOutlet weak var currentDateTime: UILabel!
    var locationManager: CLLocationManager?
    
    @IBAction func openLink(_ sender: Any) {
        if let link = forecastModel?.mobileLink, let url = URL(string: link) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.setUpView()
        if forecastModel?.temperature == nil{
            self.getLocationAndForecast()
        }
    }
    
    func setUpView(){
        if let currentLocationForecast = forecastModel,let temperatureValue = currentLocationForecast.temperature?.value, let temperatureUnit = currentLocationForecast.temperature?.unit {
            cityName = currentLocationForecast.cityName
            temperature.text = "\(temperatureValue)°\(temperatureUnit)"
            weatherType.text = currentLocationForecast.iconPhrase
            if let precipitationChance = currentLocationForecast.precipitationProbability{
                precipitationProbability.text = "\(precipitationChance)%"
            }
            if let date = currentLocationForecast.dateTime{
                let date = dateToString(isoDate: date)
                currentDateTime.text = date?.stringValue()
            }
            choosenCity.text = cityName
        }
    }
    
    func dateToString(isoDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: isoDate)
        return date
    }
    
    func getLocationAndForecast(){
        if LocationManager.isLocationAvailable && LocationManager.sharedInstance.lastLocation != nil {
            if let latitude = LocationManager.sharedInstance.lastLocation?.coordinate.latitude, let longitude = LocationManager.sharedInstance.lastLocation?.coordinate.longitude{
                print(latitude,longitude)
                SharedManager.sharedInstance.getForecastOfCurrentLocation(latLong: "\(latitude),\(longitude)", completionHandler: { (forecast: ForecastModelElement?) in
                    self.forecastModel = forecast
                    DispatchQueue.main.async {
                        self.setUpView()
                    }
                })
            }else{
                SharedManager.sharedInstance.getForecastOfCurrentLocation(latLong: Constants.fallbackLatLong, completionHandler: { (forecast: ForecastModelElement?) in
                    self.forecastModel = forecast
                    DispatchQueue.main.async {
                        self.setUpView()
                    }
                })
            }
        } else {
            DispatchQueue.main.async {
                LocationManager.sharedInstance.getLocation {(location: CLLocation?, error: NSError?) in
                    if error == nil {
                        // location is available
                        if let latitude = location?.coordinate.latitude, let longitude = location?.coordinate.longitude{
                            print(latitude,longitude)
                            SharedManager.sharedInstance.getForecastOfCurrentLocation(latLong: "\(latitude),\(longitude)", completionHandler: { (forecast: ForecastModelElement?) in
                                self.forecastModel = forecast
                                DispatchQueue.main.async {
                                    self.setUpView()
                                }
                            })
                        }else{
                            SharedManager.sharedInstance.getForecastOfCurrentLocation(latLong: Constants.fallbackLatLong, completionHandler: { (forecast: ForecastModelElement?) in
                                self.forecastModel = forecast
                                DispatchQueue.main.async {
                                    self.setUpView()
                                }
                            })
                        }
                        
                    } else{
                        SharedManager.sharedInstance.getForecastOfCurrentLocation(latLong: Constants.fallbackLatLong, completionHandler: { (forecast: ForecastModelElement?) in
                            self.forecastModel = forecast
                            DispatchQueue.main.async {
                                self.setUpView()
                            }
                        })
                    }
                }
            }
        }
    }
    
}
