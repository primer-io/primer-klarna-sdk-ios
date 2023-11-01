//
//  Date+ToString.swift
//  PrimerKlarnaSDK
//
//  Created by Illia Khrypunov on 30.10.2023.
//

import Foundation

extension Date {
    func toString(
        withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
        timeZone: TimeZone? = nil,
        calendar: Calendar? = nil
    ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = timeZone == nil ? TimeZone.current : timeZone!
        dateFormatter.calendar = calendar == nil ? Calendar(identifier: .gregorian) : calendar!
        return dateFormatter.string(from: self)
    }
}
