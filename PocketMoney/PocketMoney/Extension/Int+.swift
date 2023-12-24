//
//  Int+.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/24.
//

import Foundation

extension Int {
    func moneyString() -> String {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result: String = numberFormatter.string(for: self)!
        return result
    }
}
