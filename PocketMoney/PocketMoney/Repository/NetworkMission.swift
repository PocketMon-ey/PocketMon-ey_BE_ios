//
//  NetworkMission.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/22.
//

import Foundation
import RxSwift

class NetworkMission: CatSDKNetworkable {
    private init() {}
    static func addMission(
        childId: Int,
        mission: String,
        reward: Int,
        completion: @escaping (Result<AddMissionDTO.Response, Error>) -> Void
    ) {
        networkService.request(AddMissionAPI(request: .init(childId: childId, name: mission, reward: reward))){ result in
            switch result {
            case .success(let dto):
                completion(.success(dto))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    static func getMission(
        id: Int,
        completion: @escaping (Result<GetMissionDetailDTO.Response, Error>) -> Void
    ) {
        networkService.request(GetMissionDetailAPI(request: .init(id: id))){ result in
            switch result {
            case .success(let dto):
                completion(.success(dto))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func approveMission(
        id: Int,
        completion: @escaping (Result<ApproveMissionDTO.Response, Error>) -> Void
    ) {
        networkService.request(ApproveMissionAPI(request: .init(id: id))){ result in
            switch result {
            case .success(let dto):
                completion(.success(dto))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    static func refuseMission(
        id: Int,
        reason: String,
        completion: @escaping (Result<RefuseMissionDTO.Response, Error>) -> Void
    ) {
        networkService.request(RefuseMissionAPI(request: .init(id: id, rejectReason: reason))){ result in
            switch result {
            case .success(let dto):
                completion(.success(dto))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getMissionList(
        childId: Int,
        status: Int?,
        completion: @escaping (Result<[GetMissionListDTO.Response], Error>) -> Void
    ) {
        networkService.request(GetMissionListAPI(request: .init(childId: childId, status: status))){ result in
            switch result {
            case .success(let dto):
                completion(.success(dto))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func requestMission(
        id: Int,
        completion: @escaping (Result<ReqeustMissionDTO.Response, Error>) -> Void
    ) {
        networkService.request(ReqeustMissionAPI(request: .init(id: id))){ result in
            switch result {
            case .success(let dto):
                completion(.success(dto))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension Reactive where Base: NetworkMission {
    static func addMission(
        childId: Int,
        mission: String,
        reward: Int
    ) -> Observable<AddMissionDTO.Response> {
        Base.networkService.rx.request(AddMissionAPI(request: .init(childId: childId, name: mission, reward: reward))).asObservable()
    }
    
    static func getMission(
        id: Int
    ) -> Observable<GetMissionDetailDTO.Response> {
        Base.networkService.rx.request(GetMissionDetailAPI(request: .init(id: id))).asObservable()
    }
    static func approveMission(
        id: Int
    ) -> Observable<ApproveMissionDTO.Response> {
        Base.networkService.rx.request(ApproveMissionAPI(request: .init(id: id))).asObservable()
    }
    static func refuseMission(
        id: Int,
        reason: String
    ) -> Observable<RefuseMissionDTO.Response> {
        Base.networkService.rx.request(RefuseMissionAPI(request: .init(id: id, rejectReason: reason))).asObservable()
    }
    static func getMissionList(
        childId: Int,
        status: Int?
    ) -> Observable<[GetMissionListDTO.Response]> {
        Base.networkService.rx.request(GetMissionListAPI(request: .init(childId: childId, status: status))).asObservable()
    }
    static func requestMission(
        id: Int
    ) -> Observable<ReqeustMissionDTO.Response> {
        Base.networkService.rx.request(ReqeustMissionAPI(request: .init(id: id))).asObservable()
    }
    
    static func getAccountMoney(
        id: Int
    ) -> Observable<GetAccountMoneyDTO.Response> {
        Base.networkService.rx.request(GetAccountMoneyAPI(request: id)).asObservable()
    }
}
