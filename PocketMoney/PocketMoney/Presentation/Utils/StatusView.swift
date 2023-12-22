//
//  StatusView.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/22.
//

import UIKit

class StatusView: UIView {
    init(status: MissionStatus) {
        super.init(frame: .zero)
        layer.cornerRadius = 10
        
        setStatus(status: status)
    }
    
    public func setStatus(status: MissionStatus) {
        backgroundColor = .init(hex: status.hex())
        statusLabel.text = status.toString()
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let statusLabel: UILabel = {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
        return $0
    }(UILabel())
    
    func setUI() {
        addSubview(statusLabel)
        statusLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
