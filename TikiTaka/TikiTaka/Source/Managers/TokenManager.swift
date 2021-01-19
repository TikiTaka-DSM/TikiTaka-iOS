//
//  TokenManager.swift
//  TikiTaka
//
//  Created by 이가영 on 2021/01/19.
//

import Foundation
import Security

class TokenManager {
    
    static let shared = TokenManager()
    
    private let account = "TikiTaka"
    private let service = Bundle.main.bundleIdentifier
    
    let keyChainQuery: NSDictionary = [
        kSecClass : kSecClassGenericPassword,
        kSecAttrService : Bundle.main.bundleIdentifier ?? "default",
        kSecAttrAccount : "TikiTaka"
    ]
    
    func create(_ user: User) -> Bool {
        guard let data = try? JSONEncoder().encode(user) else { return false }
        
        let keyChainQuery: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : service!,
            kSecAttrAccount : account,
            kSecValueData : data
        ]
        
        SecItemDelete(keyChainQuery)
        
        return SecItemAdd(keyChainQuery, nil) == errSecSuccess
    }
    
    func read() -> User? {
        let keyChainQuery: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : service!,
            kSecAttrAccount : account,
            kSecReturnData : kCFBooleanTrue!, //CFData 타입으로
            kSecMatchLimit : kSecMatchLimitOne // 중복되는 경우 하나의 값만
        ]
        
        var dataTypeRef: CFTypeRef?
        let status = SecItemCopyMatching(keyChainQuery, &dataTypeRef)
        
        if status == errSecSuccess {
            let retrievedData = dataTypeRef as! Data
            let value = try? JSONDecoder().decode(User.self, from: retrievedData)
            return value
        }else {
            return nil
        }
    }
    
    func delete() -> Bool {
        let keyChainQuery: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : service!,
            kSecAttrAccount : account
        ]
        
        return SecItemDelete(keyChainQuery) == noErr
    }
    
}
