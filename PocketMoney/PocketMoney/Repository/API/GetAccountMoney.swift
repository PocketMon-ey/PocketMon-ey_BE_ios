//
//  GetAccountMoney.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/24.
//

import Foundation
import Moya

struct GetAccountMoneyDTO {
    struct Response: Decodable {
        let balance: Int
    }
}

struct GetAccountMoneyAPI: ServiceAPI {
    typealias Response = GetAccountMoneyDTO.Response
    let request: Int
    var path: String = "/user"
    var method: Moya.Method { .get }
    var task: Moya.Task {
        .requestPlain
    }
    var baseURL: URL {
        return URL(string: "http://pocketmoney.165.192.105.60.nip.io/")!
    }
    
    init(request: Int) {
        self.request = request
        self.path.append("/\(request)")
    }
}

