//
//  NetworkService.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/22.
//

import Foundation

import RxCocoa
import RxSwift
import RxMoya
import Moya

struct APIResponse<T: Decodable>: Decodable {
    let success: Bool
    let data: T?
    let message: String
}

protocol NetworkServable {
    func request<API>(_ api: API, completion: @escaping (Result<API.Response, NetworkError>) -> Void) where API: ServiceAPI
}

struct NetworkErrorResponse: Error, Decodable {
    let errorCode: Int
    let message: String
}

class NetworkService: NetworkServable {
    init() {}

    func request<API>(
        _ api: API,
        completion: @escaping (Result<API.Response, NetworkError>) -> Void
    ) where API : ServiceAPI {

        let provider = MoyaProvider<API>()
        let endpoint = MultiTarget.target(api)
//        print(endpoint.headers)
        print("request😎")
        dump(endpoint.target.task)
        print(endpoint.target.path)
        provider.request(api) { result in
            switch result {
            case .success(let response):
                do {
                    if response.statusCode == 500 {
                        let a = try response.map(NetworkErrorResponse.self)
                        print(a)
                    }
                    print(response," ➡️")
                    let a = try? JSONDecoder().decode(APIResponse<API.Response>.self, from: response.data)
                    print(a)
                    _ = try response.filterSuccessfulStatusCodes()
                    let decodedData = try response.map(APIResponse<API.Response>.self)
                    if let data = decodedData.data {
                        completion(.success(data))
                    }
                } catch let error {
                    print(error)
                    completion(.failure(handlingError(error)))
                }
            case .failure(let error):
                completion(.failure(handlingError(error)))
            }
        }

        func handlingError(_ error: Error) -> NetworkError {
            guard let moyaError = error as? MoyaError else {
                return .unknown
            }

            let error: NetworkError

            switch moyaError {
            case .jsonMapping(_):
                print("인코딩 에러")
                error = .mappingError
                
            case .objectMapping(_, let response):
                print("디코딩 에러")
                error = .mappingError
            case .statusCode(let response):
                switch response.statusCode {
                case 400..<500:
                    do {
                        let errorModel = try response.map(NetworkErrorResponse.self)
                        error = .clientError(errorModel.errorCode, errorModel.message)
                    } catch {
                        let error = NetworkError.mappingError
                        print(error.localizedDescription)
                        return error
                    }
                default:
                    error = .statusCode(response.statusCode)
                }
                
            default: error = .unknown
            }

            print(error.localizedDescription)
            return error
        }
    }
}
