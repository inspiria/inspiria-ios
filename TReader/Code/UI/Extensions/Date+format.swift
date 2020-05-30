//
//  Date+format.swift
//  TReader
//
//  Created by tadas on 2020-05-30.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation

extension Date {
    func formatedString() -> String {
        let calendar = Calendar.autoupdatingCurrent
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = true

        if calendar.isDateInToday(self) {
            formatter.timeStyle = .short
            formatter.dateStyle = .none
        } else if calendar.isDateInYesterday(self) {
            formatter.timeStyle = .short
            formatter.dateStyle = .medium
        } else {
            formatter.timeStyle = .none
            formatter.dateStyle = .medium
        }

        return formatter.string(from: self)
    }
}
