//
//  ReqeustMission.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/22.
//

import Foundation
import Moya

struct ReqeustMissionAPI: ServiceAPI {
    typealias Response = ReqeustMissionDTO.Response
    let request: ReqeustMissionDTO.Request
    var path: String = "/mission/success"
    var method: Moya.Method { .put }
    var task: Moya.Task { .requestJSONEncodable(request) }
    
    init(request: ReqeustMissionDTO.Request) {
        self.request = request
    }
}
