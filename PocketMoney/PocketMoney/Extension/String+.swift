//
//  String+.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/24.
//

import Foundation
extension String {
    func moneyInt() -> Int {
//        self.components(separatedBy: ",")
//            .reduce("") { $0.appending($1) }
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let num = numberFormatter.number(from: self) else {
            return 0
        }
        return Int(num)
    }
}
