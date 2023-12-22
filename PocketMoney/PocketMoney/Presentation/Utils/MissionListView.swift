//
//  MissionListView.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/22.
//

import UIKit
class MissionListView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero,
                                  collectionViewLayout: flowLayout)

        cv.register(MissionCell.self, forCellWithReuseIdentifier: "mission")

        cv.showsVerticalScrollIndicator = false
        cv.isScrollEnabled = false
        return cv
    }()

    private lazy var flowLayout: UICollectionViewLayout = {
        let minLineSpacing: CGFloat = 20
        let minInterSpacing: CGFloat = 10
        let itemWidth = (UIScreen.main.bounds.width - 60) / 2

        let layout = UICollectionViewFlowLayout()

        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = minLineSpacing
        layout.minimumInteritemSpacing = minInterSpacing
        layout.sectionInset = .init(top: 0, left: 0.5, bottom: 20, right: 0.5)
        
        return layout
    }()
    
    func setUI() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
    }
}
