//
//  AddMission.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/22.
//

import Foundation
import Moya

struct AddMissionAPI: ServiceAPI {
    typealias Response = AddMissionDTO.Response
    let request: AddMissionDTO.Request
    var path: String = "/mission"
    var method: Moya.Method { .post }
    var task: Moya.Task { .requestJSONEncodable(request) }
    
    init(request: AddMissionDTO.Request) {
        self.request = request
    }
}
