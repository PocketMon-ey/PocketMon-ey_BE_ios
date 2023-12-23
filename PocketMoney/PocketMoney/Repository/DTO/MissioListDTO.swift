//
//  MissioListDTO.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/22.
//

import Foundation

struct AddMissionDTO {
    struct Request: Encodable {
        let childId: Int
        let name: String
        let reward: Int
    }
    
    struct Response: Decodable {
        let childId: Int
        let createDate: String
        let doneDate: String?
        let id: Int
        let name: String
        let reward: Int
        let status: Int
        
    }
}

struct GetMissionDetailDTO {
    struct Request: Encodable {
        let id: Int
    }
    
    struct Response: Decodable {
        let childId: Int
        let createDate: String
        let doneDate: String?
        let id: Int
        let name: String
        let reward: Int
        let status: Int
        let rejectReason: String?
    }
}

struct ApproveMissionDTO {
    struct Request: Encodable {
        let id: Int
    }
    
    struct Response: Decodable {
        let childId: Int
        let createDate: String
        let doneDate: String?
        let id: Int
        let name: String
        let reward: Int
        let status: Int
    }
}

struct RefuseMissionDTO {
    struct Request: Encodable {
        let id: Int
    }
    
    struct Response: Decodable {
        let childId: Int
        let createDate: String
        let doneDate: String?
        let id: Int
        let name: String
        let reward: Int
        let status: Int
    }
}
struct GetMissionListDTO {
    struct Request: Encodable {
        let childId: Int
        let status: Int?
    }
    
    struct Response: Decodable {
        let childId: Int
        let createDate: String
        let doneDate: String?
        let id: Int
        let name: String
        let reward: Int
        let status: Int
        let rejectReason: String?
    }
}
struct ReqeustMissionDTO {
    struct Request: Encodable {
        let id: Int
    }
    
    struct Response: Decodable {
        let childId: Int
        let createDate: String
        let doneDate: String?
        let id: Int
        let name: String
        let reward: Int
        let status: Int
    }
}

