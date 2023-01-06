import Foundation

// MARK: - ForecastModelElement
// MARK: - ForecastModelElement
struct ForecastModelElement: Codable {
    let dateTime: String?
    let epochDateTime, weatherIcon: Int?
    let iconPhrase: String?
    let hasPrecipitation, isDaylight: Bool?
    let temperature: Temperature?
    let precipitationProbability: Int?
    let mobileLink, link: String?
    var cityName: String?

    enum CodingKeys: String, CodingKey {
        case dateTime = "DateTime"
        case epochDateTime = "EpochDateTime"
        case weatherIcon = "WeatherIcon"
        case iconPhrase = "IconPhrase"
        case hasPrecipitation = "HasPrecipitation"
        case isDaylight = "IsDaylight"
        case temperature = "Temperature"
        case precipitationProbability = "PrecipitationProbability"
        case mobileLink = "MobileLink"
        case link = "Link"
        case cityName = "CityName"
    }
}

// MARK: - Temperature
struct Temperature: Codable {
    let value: Int?
    let unit: String?
    let unitType: Int?

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case unit = "Unit"
        case unitType = "UnitType"
    }
}

typealias ForecastModel = [ForecastModelElement]






