import Foundation

struct Constants {
    static let API_KEY = "yRuGwIL7usGSSDSYjHxupYKRxGeWGVp0"//bxAg4qUngGqb5ufAcUXs2DgsKrxGLcsk"
    static let baseURL = "http://dataservice.accuweather.com"
    static let citySearchEndPoint = "/locations/v1/cities/search" //apikey,q(name)
    static let geoPositionSearchEndPoint = "/locations/v1/cities/geoposition/search" //apikey,q(lat,long)
    static let currentForecastEndPoint = "/forecasts/v1/hourly/1hour/" //apikey
    static let fallbackLatLong = "21.1458,79.0882" //nagpur lat long
    static let searchStorageKey = "SearchStorageKey"
}

enum APIError: Error {
    case failedTogetData
}

class APICaller{
    static let shared = APICaller()
    
    // MARK: 1. Get weather forecast from location key
    func getWeatherForecast(locationKey: String,completion: @escaping (Result<ForecastModel, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)\(Constants.currentForecastEndPoint)\(locationKey)?apikey=\(Constants.API_KEY)") else {return}
        print("URL: \(url)")
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(ForecastModel.self, from: data)
                completion(.success(result))
                print("result: \(result)")
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    // MARK: 2. Get location key from lat long API
    func getLocationFromGeoPosition(geoPosition:String,completion: @escaping (Result<GeoPositionSearchModel, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)\(Constants.geoPositionSearchEndPoint)?apikey=\(Constants.API_KEY)&q=\(geoPosition)") else {return}
        print("URL: \(url)")
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode(GeoPositionSearchModel.self, from: data)
                completion(.success(result))
                print("result: \(result)")
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    // MARK: 3. Search API
    func searchLocationKey(query: String,completion: @escaping (Result<[GeoPositionSearchModel], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)\(Constants.citySearchEndPoint)?apikey=\(Constants.API_KEY)&q=\(query)") else {return}
        print("URL: \(url)")
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let result = try JSONDecoder().decode([GeoPositionSearchModel].self, from: data)
                completion(.success(result))
                print("result: \(result)")
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
}
