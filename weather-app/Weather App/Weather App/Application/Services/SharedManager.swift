import UIKit
import CoreLocation

class SharedManager {
    
    static let sharedInstance = SharedManager()
    typealias ForecastClosure = ((_ forecast: ForecastModelElement?) -> Void)
    private var forecastCompletionHandler: ForecastClosure?
    var currentLocationForecast: ForecastModelElement?
    var cityName: String?
    
    func getForecastOfCurrentLocation(latLong: String,completionHandler: @escaping ForecastClosure){
        APICaller.shared.getLocationFromGeoPosition(geoPosition: latLong){ result in
            switch result {
            case .success(let response):
                if let key = response.key{
                    if let cityName = response.englishName{
                        self.cityName = cityName
                    }
                    APICaller.shared.getWeatherForecast(locationKey: key){ result in
                        switch result {
                        case .success(let response):
                            print(response)
                            if !response.isEmpty{
                                self.currentLocationForecast = response.first
                                self.currentLocationForecast?.cityName = self.cityName
                                self.forecastCompletionHandler = completionHandler
                                self.forecastCompletionHandler?(self.currentLocationForecast)
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
