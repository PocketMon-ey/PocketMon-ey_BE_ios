//
//  NetworkService+Rx.swift
//  BlackCatSDK
//
//  Created by SeYeong on 2022/11/08.
//

import Foundation

import RxCocoa
import RxSwift

extension NetworkService: ReactiveCompatible {}

extension Reactive where Base: NetworkService {
    func request<API>(_ api: API) -> Single<API.Response> where API : ServiceAPI {
        return Single.create { single in
            base.request(api) { result in
                switch result {
                case .success(let decodedData):
                    single(.success(decodedData))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
