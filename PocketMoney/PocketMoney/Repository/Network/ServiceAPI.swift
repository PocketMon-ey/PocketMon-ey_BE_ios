//
//  ServiceAPI.swift
//  BlackCatSDK
//
//  Created by SeYeong on 2022/10/10.
//

import Foundation
import Moya

public protocol ServiceAPI: TargetType {
    associatedtype Response: Decodable

    var path: String { get }
    var method: Moya.Method { get }
    var task: Moya.Task { get }
}

extension ServiceAPI {
    var baseURL: URL {
        return URL(string: "http://pocketmoney-mission.165.192.105.60.nip.io/")!
    }

    var headers: [String : String]? {
        ["Content-type": "application/json"]
    }
}
