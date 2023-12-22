//
//  GetMissionDetail.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/22.
//

import Foundation
import Moya

struct GetMissionDetailAPI: ServiceAPI {
    typealias Response = GetMissionDetailDTO.Response
    let request: GetMissionDetailDTO.Request
    var path: String = "/mission"
    var method: Moya.Method { .get }
    var task: Moya.Task {
        .requestPlain
    }
    
    init(request: GetMissionDetailDTO.Request) {
        self.request = request
        self.path.append("/\(request.id)")
    }
}
