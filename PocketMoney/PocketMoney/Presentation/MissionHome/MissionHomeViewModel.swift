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
    let status: PublishRelay<Int> = .init()
    let viewDidLoadRelay: PublishRelay<Void> = .init()
    let itemSelectedRelay: PublishRelay<Int> = .init()
    
    // OUTPUT
    var missionCompleteTextDriver: Driver<String>
    var creditRatingTextDriver: Driver<String>
    var dataSource: Driver<[MissionCellItem]>
    var showDetailViewDriver: Driver<MissionDetailViewModel>
    var statusChangeDriver: Driver<Int>
    var testa: Driver<Int>
    init() {
        func test(t: Int) -> Observable<[MissionCellItem]> {
            return Observable.just(Array(repeating: MissionCellItem(status: .wait, date: "\(t)", title: "b", price: t), count: t))
        }
        missionCompleteTextDriver = viewDidLoadRelay
            .map { _ in "test" }
            .asDriver(onErrorJustReturn: "a")
        
        creditRatingTextDriver = viewDidLoadRelay
            .map { _ in "test" }
            .asDriver(onErrorJustReturn: "a")
        
        let fetchedItems = status.map { ($0 + 1) * 2 }
            .flatMap(test)
            .share()
            
        dataSource = fetchedItems
            .asDriver(onErrorJustReturn: [])
        
        testa = fetchedItems
            .map { $0.count }
            .asDriver(onErrorJustReturn: 0)
        
        showDetailViewDriver = itemSelectedRelay
            .withLatestFrom(dataSource.asObservable()) { ($0, $1)}
            .map { $0.1[$0.0].missionId }
            .map { MissionDetailViewModel(missionId: $0) }
            .asDriver(onErrorJustReturn: .init(missionId: -1))
        
        statusChangeDriver = status
            .asDriver(onErrorJustReturn: 0)
    }
}
