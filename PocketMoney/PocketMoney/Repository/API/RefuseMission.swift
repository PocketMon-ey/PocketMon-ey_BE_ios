//
//  RefuseMission.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/22.
//

import Foundation
import Moya

struct RefuseMissionAPI: ServiceAPI {
    typealias Response = RefuseMissionDTO.Response
    let request: RefuseMissionDTO.Request
    var path: String = "/mission/fail"
    var method: Moya.Method { .put }
    var task: Moya.Task { .requestJSONEncodable(request) }
    
    init(request: RefuseMissionDTO.Request) {
        self.request = request
    }
}
