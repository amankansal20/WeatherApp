import Foundation

// MARK: - CitySearchModelElement
struct CitySearchModelElement: Codable {
    let version: Int?
    let key: String?
    let type: TypeEnum?
    let rank: Int?
    let localizedName, englishName: String?
    let primaryPostalCode: String?
    let region, country: Country?
    let administrativeArea: AdministrativeArea?
    let timeZone: TimeZone?
    let geoPosition: GeoPosition?
    let isAlias: Bool?
    let supplementalAdminAreas: [SupplementalAdminArea]?
    let dataSets: [DataSet]?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case key = "Key"
        case type = "Type"
        case rank = "Rank"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
        case primaryPostalCode = "PrimaryPostalCode"
        case region = "Region"
        case country = "Country"
        case administrativeArea = "AdministrativeArea"
        case timeZone = "TimeZone"
        case geoPosition = "GeoPosition"
        case isAlias = "IsAlias"
        case supplementalAdminAreas = "SupplementalAdminAreas"
        case dataSets = "DataSets"
    }
}

enum CountryID: String, Codable {
    case asi = "ASI"
    case countryIDIN = "IN"
    case ir = "IR"
    case mea = "MEA"
}

enum EnglishTypeEnum: String, Codable {
    case province = "Province"
    case state = "State"
}

// MARK: - Country
struct Country: Codable {
    let id: CountryID?
    let localizedName, englishName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case localizedName
        case englishName
    }
}

enum DataSet: String, Codable {
    case airQualityCurrentConditions = "AirQualityCurrentConditions"
    case airQualityForecasts = "AirQualityForecasts"
    case alerts = "Alerts"
    case forecastConfidence = "ForecastConfidence"
    case futureRadar = "FutureRadar"
    case minuteCast = "MinuteCast"
    case premiumAirQuality = "PremiumAirQuality"
}

enum TypeEnum: String, Codable {
    case city = "City"
}

typealias CitySearchModel = [CitySearchModelElement]
