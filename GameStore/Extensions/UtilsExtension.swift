import Foundation

extension String {

    func toDateFormattedString(from fromDateFormat: String, to toDateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromDateFormat

        guard let date = dateFormatter.date(from: self) else { return "" }

        dateFormatter.dateFormat = toDateFormat
        return dateFormatter.string(from: date)
    }

}
