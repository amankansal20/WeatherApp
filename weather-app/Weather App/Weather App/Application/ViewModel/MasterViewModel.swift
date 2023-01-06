import UIKit
import Foundation

protocol MasterViewDelegate: NSObject {
    func reloadTable()
}

class MasterViewModel: NSObject {
    weak var delegate: MasterViewDelegate?
    var vc: MasterVC?
    var navController: UINavigationController?
    
    func getForecastOfCurrentLocation(latLong: String){
        APICaller.shared.getLocationFromGeoPosition(geoPosition: latLong){ result in
            switch result {
            case .success(let response):
                if let key = response.key{
                    if let cityName = response.englishName{
                        self.vc?.currentCityName = cityName
                    }
                    APICaller.shared.getWeatherForecast(locationKey: key){ result in
                        switch result {
                        case .success(let response):
                            print(response)
                            if !response.isEmpty{
                                self.vc?.currentLocationForecast = response.first
                                self.vc?.currentLocationForecast?.cityName = self.vc?.currentCityName
                                self.delegate?.reloadTable()
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

// MARK: - UITableViewDataSource
extension MasterViewModel: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentLocationForecast = vc?.currentLocationForecast {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.className,for: indexPath) as? Cell else {return UITableViewCell()}
        cell.selectionStyle = .none
        if let currentLocationForecast = vc?.currentLocationForecast,let temperatureValue = currentLocationForecast.temperature?.value, let temperatureUnit = currentLocationForecast.temperature?.unit{
            cell.cityName.text = currentLocationForecast.cityName
            cell.temperature.text = "\(temperatureValue)°\(temperatureUnit)"
            cell.weatherType.text = currentLocationForecast.iconPhrase
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let currentLocationForecast = vc?.currentLocationForecast{
            vc?.coordinator?.pushToWeatherDetail(forecastModel: currentLocationForecast)
        }
    }
}


public protocol ClassNameProtocol {
    
    static var className: String { get }
    var className: String { get }
    
}

public extension ClassNameProtocol {
    
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
    
}

extension NSObject: ClassNameProtocol {}
