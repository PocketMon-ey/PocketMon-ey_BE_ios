//
//  NetworkError.swift
//  BlackCatSDK
//
//  Created by SeYeong on 2022/11/08.
//

import Foundation
import Moya

enum NetworkError: Error {
    typealias ErrorCode = Int
    typealias Message = String
    typealias StatusCode = Int

    /** Decodable 객체로 매핑 실패 시  */ case mappingError
    /** statusCode가 200...299 400...499 범위 밖일 때 */ case statusCode(StatusCode)
    case clientError(ErrorCode, Message)
    case unknown
}

extension NetworkError {
    var localizedDescription: String {
        switch self {
        case .mappingError:
            return "맵핑 에러"
        case .statusCode(let statusCode):
            return "올바르지 않은 StatusCode입니다... StatusCode: \(statusCode)"
        case .clientError(let errorCode, let message):
            return "errorCode: \(errorCode), message: \(message)"
        case .unknown:
            return "알 수 없는 에러입니다"
        }
    }
}
