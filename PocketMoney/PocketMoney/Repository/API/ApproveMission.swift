//
//  ApproveMission.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/22.
//

import Foundation
import Moya

struct ApproveMissionAPI: ServiceAPI {
    typealias Response = ApproveMissionDTO.Response
    let request: ApproveMissionDTO.Request
    var path: String = "/mission/approve"
    var method: Moya.Method { .put }
    var task: Moya.Task { .requestPlain}
    
    init(request: ApproveMissionDTO.Request) {
        self.request = request
        self.path.append("/\(request.id)")
    }
}
