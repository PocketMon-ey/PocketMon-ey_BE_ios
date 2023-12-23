//
//  MissionDetailViewModel.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/23.
//

import Foundation
import RxSwift
import RxCocoa
enum MissionStatus: Int, CaseIterable{
    case wait, request, approve, refuse
    
    func hex() -> String {
        switch self {
        case .wait:
            return "#636366FF"
        case .request:
            return "#00FF00FF"
        case .approve:
            return "#0000FFFF"
        case .refuse:
            return "#FF0000FF"
        }
    }
    func detailMent() -> String {
        switch self {
        case .wait:
            return "asd"
        case .request:
            return "asda"
        case .approve:
            return "3"
        case .refuse:
            return "4"
        }
    }
    
    func toString() -> String {
        switch self {
        case .wait:
            return "대기중"
        case .request:
            return "완료요청"
        case .approve:
            return "승인됨"
        case .refuse:
            return "거절됨"
        }
    }
}


class MissionDetailViewModel {
    // Input
    let viewWillAppearRelay = PublishRelay<Void>()
    let requestTrigger = PublishRelay<Void>()
    let approveTrigger = PublishRelay<Void>()
    let refuseTrigger = PublishRelay<Void>()
    
    // Output
    let requestButtonIsHiddenDriver: Driver<Bool>
    let twoButtonsIsHiddenDriver: Driver<Bool>
    let statusDriver: Driver<MissionStatus>
    let missionDriver: Driver<String>
    let priceDriver: Driver<String>
    let refuseDriver: Driver<String>
    
    let popDriver: Driver<Void>
    
    init(mission: MissionCellItem) {
        let isChild = UserDefaultManager.isChild
        
        requestButtonIsHiddenDriver = viewWillAppearRelay
            .map { _ in !(isChild && mission.status == .wait) }
            .asDriver(onErrorJustReturn: true)
            
        twoButtonsIsHiddenDriver = viewWillAppearRelay
            .map { _ in !(!isChild && mission.status == .request) }
            .asDriver(onErrorJustReturn: true)
        
        let requestResult = requestTrigger
            .flatMap { _ in NetworkMission.rx.requestMission(id: mission.missionId) }
            .map { _ in () }
            .share()
        
        let approveResult = approveTrigger
            .flatMap { _ in NetworkMission.rx.approveMission(id: mission.missionId) }
            .do { _ in UserDefaultManager.approveCount += 1}
            .map { _ in () }
            .share()
        
        let refuseResult = refuseTrigger
            .flatMap { _ in NetworkMission.rx.refuseMission(id: mission.missionId) }
            .do { _ in UserDefaultManager.rejectCount += 1}
            .map { _ in () }
            .share()
        
        popDriver = Observable.merge([requestResult, approveResult, refuseResult])
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
        
        statusDriver = .just(mission.status)
        missionDriver = .just(mission.title)
        priceDriver = .just("\(mission.price)")
        refuseDriver = .just(mission.rejectReason)
    }
}
