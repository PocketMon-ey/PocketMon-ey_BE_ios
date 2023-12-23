//
//  MissionHomeViewModel.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/22.
//

import UIKit
import RxSwift
import RxCocoa

class MissionHomeViewModel {
    // INPUT
    let status: BehaviorRelay<Int> = .init(value: 0)
    let viewDidLoadRelay: PublishRelay<Void> = .init()
    let viewWillAppearRelay: PublishRelay<Bool> = .init()
    let itemSelectedRelay: PublishRelay<Int> = .init()
    
    
    // OUTPUT
    var missionCompleteTextDriver: Driver<String>
    var creditRatingTextDriver: Driver<String>
    var dataSource: Driver<[MissionCellItem]>
    var showDetailViewDriver: Driver<MissionDetailViewModel>
    var statusChangeDriver: Driver<Int>
    var testa: Driver<Int>
    init() {
        func creditRate() -> Int {
            let creditRate = 500 - UserDefaultManager.addCount * 20 - UserDefaultManager.rejectCount * 40 + UserDefaultManager.approveCount * 50
            if creditRate < 0 {
                return 0
            }
            if creditRate > 1000 {
                return 1000
            }
            return creditRate
        }
        
        missionCompleteTextDriver = viewWillAppearRelay
            .map { _ in "미션달성률: \(UserDefaultManager.addCount == 0 ? 0 : UserDefaultManager.approveCount / UserDefaultManager.addCount * 100)%" }
            .asDriver(onErrorJustReturn: "a")
        creditRatingTextDriver = viewWillAppearRelay
            .map { _ in "신용도: \(creditRate())/1000" }
            .asDriver(onErrorJustReturn: "a")
        
        let fetchedMissions = status
            .flatMap { status in NetworkMission.rx.getMissionList(childId: 2, status: status)}
            .debug("😡")
            .share()
        
        let fetchedItems = fetchedMissions
            .map { $0.map { dto in MissionCellItem(missionId: dto.id, status: MissionStatus(rawValue: dto.status) ?? MissionStatus.wait, date: dto.createDate, title: dto.name, price: dto.reward, rejectReason: dto.rejectReason ?? "") } }
            .share()
            
        dataSource = fetchedItems
            .asDriver(onErrorJustReturn: [])
        
        testa = fetchedItems
            .map { $0.count }
            .asDriver(onErrorJustReturn: 0)
        
        showDetailViewDriver = itemSelectedRelay
            .withLatestFrom(fetchedItems) { ($0, $1) }
            .map { $0.1[$0.0] }
            .map { MissionDetailViewModel(mission: $0) }
            .asDriver(onErrorJustReturn: .init(mission:.init(missionId: -1, status: .wait, date: "", title: "", price: 0, rejectReason: "")))
        
        statusChangeDriver = status
            .asDriver(onErrorJustReturn: 0)
    }
}
