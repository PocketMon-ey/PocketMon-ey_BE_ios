//
//  Networkable.swift
//  BlackCatSDK
//
//  Created by SeYeong on 2022/11/08.
//

import Foundation

import RxSwift

public protocol CatSDKNetworkable: ReactiveCompatible {}

extension CatSDKNetworkable {
    static var networkService: NetworkService { NetworkService() }
    static var converter: DTOConverter { DTOConverter() }
}
