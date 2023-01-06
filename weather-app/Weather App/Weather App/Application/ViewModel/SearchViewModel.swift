import UIKit
import Foundation

protocol SearchViewDelegate: NSObject {
    func reloadTable()
    func reloadSectionTable(section: Int)
}

class SearchViewModel: NSObject {
    weak var delegate: SearchViewDelegate?
    var vc: SearchViewController?
    var navController: UINavigationController?
    let userDefaults = UserDefaults.standard
    var cityMap: [String: Any] = [:]
    
    
    func getForecastOfSearchLocation(query: String){
        APICaller.shared.searchLocationKey(query: query){ result in
            switch result {
            case .success(let response):
                if !response.isEmpty{
                    self.vc?.searchCities = response
                    if let searchCity = self.vc?.searchCities?.first,let key = searchCity.key{
                        if let city = searchCity.englishName{
                            var country: String = ""
                            country = searchCity.country?.englishName ?? ""
                            var state: String = ""
                            state = searchCity.administrativeArea?.englishName ?? ""
                            self.cityMap[key] = "\(city), \(state), \(country)"
                            self.userDefaults.set(self.cityMap, forKey: Constants.searchStorageKey)
                        }
                        
                    }
                    
                }
                self.delegate?.reloadSectionTable(section: 1)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getForecastForSelectedCity(locationKey: String){
        APICaller.shared.getWeatherForecast(locationKey: locationKey){ result in
            switch result {
            case .success(let response):
                print(response)
                if !response.isEmpty{
                    self.vc?.currentLocationForecast = response.first
                    self.vc?.currentLocationForecast?.cityName = self.vc?.currentCityName
                    if let currentLocationForecast = self.vc?.currentLocationForecast{
                        DispatchQueue.main.async {
                            self.vc?.coordinator?.pushToWeatherDetail(forecastModel: currentLocationForecast)
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func searchCity(searchString: String, newLength: Int){
        guard newLength != 0  else { return }
        self.getForecastOfSearchLocation(query: searchString)
    }
}

// MARK: - UITableViewDataSource
extension SearchViewModel: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            if self.vc?.searchCities?.count ?? 0 > 0{
                return self.vc?.searchCities?.count ?? 0 > 10 ? 10 : self.vc?.searchCities?.count ?? 0
            }else{
                return self.cityMap.count > 5 ? 5 : self.cityMap.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchBarTableViewCell.className,for: indexPath) as? SearchBarTableViewCell else {return UITableViewCell()}
            cell.selectionStyle = .none
            cell.searchBarAction = {(searchText, newLength) in
                self.searchCity(searchString: searchText, newLength: newLength)
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.className,for: indexPath) as? CityTableViewCell else {return UITableViewCell()}
            cell.selectionStyle = .none
            if self.vc?.searchCities?.count ?? 0 > 0{
                if let searchCity = self.vc?.searchCities?[indexPath.row] {
                    if let city = searchCity.englishName{
                        var country: String = ""
                        country = searchCity.country?.englishName ?? ""
                        var state: String = ""
                        state = searchCity.administrativeArea?.englishName ?? ""
                        cell.cityName.text = "\(city), \(state), \(country)"
                    }
                }
            }else{
                var searchCity = Array(self.cityMap.values.map{ $0 })
                let city: String = searchCity[indexPath.row] as! String
                cell.cityName.text = "\(city)"
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let searchCity = self.vc?.searchCities?[indexPath.row],let currentCityName = searchCity.englishName,let key = searchCity.key{
            self.vc?.currentCityName = currentCityName
            self.getForecastForSelectedCity(locationKey: key)
        }else{
            if !self.cityMap.isEmpty{
                var searchCityKey = Array(self.cityMap.keys.map{ $0 })
                let key: String = searchCityKey[indexPath.row] as! String
                var searchCity = Array(self.cityMap.values.map{ $0 })
                let city: String = searchCity[indexPath.row] as! String
                self.vc?.currentCityName = city
                self.getForecastForSelectedCity(locationKey: key)
            }
        }
    }
}
