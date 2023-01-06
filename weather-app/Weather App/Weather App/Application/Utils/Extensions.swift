import Foundation

extension Date {
    public func stringValue(_ format: String? = "dd-MMM-yyyy HH:mm") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
