//
//  MissionCell.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/22.
//

import UIKit

class MissionCellItem {
    var missionId: Int
    let status: MissionStatus
    let date: String
    let title: String
    let price: Int
    let rejectReason: String
    
    init(missionId: Int, status: MissionStatus, date: String, title: String, price: Int, rejectReason: String) {
        self.missionId = missionId
        self.status = status
        self.date = date
        self.title = title
        self.price = price
        self.rejectReason = rejectReason
    }
}

class MissionCell: UICollectionViewCell {
    var item: MissionCellItem?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.init(hex: "#C7C7CCFF")?.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with item: MissionCellItem) {
        self.item = item
        statusView.setStatus(status: item.status)
        dateLabel.text = item.date
        titleLabel.text = item.title
        priceLabel.text = "\(item.price)"
    }

    override func prepareForReuse() {
        dateLabel.text = nil
        titleLabel.text = nil
        priceLabel.text = nil
    }
    
    // MARK: - UIComponents
    let statusView = StatusView(status: .wait)
    let dateLabel: UILabel = {
        $0.textColor = .init(hex: "#8E8E93FF")
        return $0
    }(UILabel())
    let titleLabel: UILabel = {
        return $0
    }(UILabel())
    let priceLabel: UILabel = {
        return $0
    }(UILabel())
    
    func setUI() {
        [statusView, dateLabel,titleLabel,priceLabel].forEach {
            addSubview($0)
        }
        
        statusView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(5)
            $0.width.equalTo(Constant.width * 60)
            $0.height.equalTo(Constant.height * 20)
        }
        dateLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(5)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(statusView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(12)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(12)
        }
    }
}
