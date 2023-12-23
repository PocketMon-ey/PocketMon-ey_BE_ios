//
//  CommonButtonView.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/22.
//

import UIKit

class CommonButtonView: UIView {
    init(text: String?, backgroundColor: UIColor?) {
        super.init(frame: .zero)
        textLabel.text = text
        self.backgroundColor = backgroundColor;
        textLabel.textColor = .white
        textLabel.font = .boldSystemFont(ofSize:20)
        layer.cornerRadius = 7
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let textLabel: UILabel = {
        return $0
    }(UILabel())
    
    func setUI() {
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
