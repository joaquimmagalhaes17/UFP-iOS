//
//  Keychain.swift
//  UFP
//
//  Created by Rafael Almeida on 20/03/17.
//  Copyright © 2016 Sazzad Hissain Khan.
//  http://stackoverflow.com/questions/37539997/save-and-load-from-keychain-swift
//

import Foundation
import Security

let userAccount = "AuthenticatedUser"
let accessGroup = "SecuritySerivice"

let userNumberKey = "userNumber"
let userPasswordKey = "userPassword"

// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

open class KeychainService: NSObject {

    /**
     * Exposed methods to perform save and load queries.
     */

    open class func saveUserNumber(_ token: NSString) {
        self.save(userNumberKey as NSString, data: token)
    }

    open class func loadUserNumber() -> NSString? {
        return self.load(userNumberKey as NSString)
    }

    open class func saveUserPassword(_ token: NSString) {
        self.save(userPasswordKey as NSString, data: token)
    }

    open class func loadUserPassword() -> NSString? {
        return self.load(userPasswordKey as NSString)
    }

    /**
     * Internal methods for querying the keychain.
     */

    fileprivate class func save(_ service: NSString, data: NSString) {
        let dataFromString: Data = data.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)! as Data

        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])

        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)

        // Add the new keychain item
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }

    fileprivate class func load(_ service: NSString) -> NSString? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])

        var dataTypeRef :AnyObject?

        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: NSString? = nil

        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                contentsOfKeychain = NSString(data: retrievedData as Data, encoding: String.Encoding.utf8.rawValue)
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }

        return contentsOfKeychain
    }
}
