//
//  GetMissionList.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/22.
//

import Foundation
import Moya

struct GetMissionListAPI: ServiceAPI {
    typealias Response = [GetMissionListDTO.Response]
    let request: GetMissionListDTO.Request
    var path: String = "/mission/list"
    var method: Moya.Method { .get }
    var task: Moya.Task {
        .requestPlain
    }
    
    init(request: GetMissionListDTO.Request) {
        self.request = request
        self.path.append("/\(request.childId)")
        if let status = request.status {
            self.path.append("/\(status)")
        }
    }
}
