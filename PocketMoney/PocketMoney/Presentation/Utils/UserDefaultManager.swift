//
//  UserDefaultManager.swift
//  PocketMoney
//
//  Created by 김지훈 on 2023/12/22.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

public struct UserDefaultManager {
    @UserDefault(key: "userId", defaultValue: 1)
    public static var userId: Int
    @UserDefault(key: "isChild", defaultValue: true)
    public static var isChild: Bool
    
    @UserDefault(key: "approveCount", defaultValue: 0)
    public static var approveCount: Int
    @UserDefault(key: "rejectCount", defaultValue: 0)
    public static var rejectCount: Int
    @UserDefault(key: "addCount", defaultValue: 0)
    public static var addCount: Int
    @UserDefault(key: "creditRate", defaultValue: 500)
    public static var creditRate: Int

}

@propertyWrapper
public struct UserDefault<T: Codable> {
    private let key: String
    private let defaultValue: T
    public let storage: UserDefaults

    init(key: String, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }

    public var wrappedValue: T {
        get {
            guard let data = self.storage.object(forKey: key) as? Data else {
                return defaultValue
            }

            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)

            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
