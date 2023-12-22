//
//  CatSDKEncoding.swift
//  BlackCatSDK
//
//  Created by 김지훈 on 2023/03/09.
//

import Foundation
import Alamofire

struct BlackCatQueryStringEncoding: ParameterEncoding {
    
    static let `default` = BlackCatQueryStringEncoding()
    
    func encode(_ urlRequest: Alamofire.URLRequestConvertible, with parameters: Alamofire.Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        print(request, "💡💡")
        guard let parameters = parameters else {return request}
        
        guard let url = request.url else {
            throw AFError.parameterEncodingFailed(reason: .missingURL)
        }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
            urlComponents.percentEncodedQuery = percentEncodedQuery
            request.url = urlComponents.url
        }
        return request
    }
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    private func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let array = value as? [Any] {
            components.append((key, array.map { "\($0)" }.joined(separator: ",") ))
        } else if let value = value as? NSNumber {
            if value is Bool {
                components.append((key, value.boolValue ? "1" : "0"))
            } else {
                components.append((key, "\(value)"))
            }
        } else {
            components.append((key, "\(value)"))
        }
        return components
    }
}
