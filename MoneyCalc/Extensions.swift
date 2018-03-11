//
//  Extensions.swift
//  MoneyCalc
//
//  Created by Evgeniy on 11.03.18.
//  Copyright © 2018 Mike Ovyan. All rights reserved.
//

import Foundation

extension String {
    var prettyNumber: String {
        guard let number = Int(self) as NSNumber? else { return "" }

        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.groupingSeparator = " "

        return f.string(from: number) ?? "0"
    }

    var stripped: String { return replacingOccurrences(of: " ", with: "") }
}

extension Int {
    var prettyNumber: String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.groupingSeparator = " "

        return f.string(from: self as NSNumber) ?? "0"
    }
}
