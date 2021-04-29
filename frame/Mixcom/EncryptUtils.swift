//
//  EncryptUtils.swift
//  sls
//
//  Created by yl on 16/1/11.
//  Copyright © 2016年 yl. All rights reserved.
//

import Foundation
import CryptoSwift

private let IV: String = "ZJSH!@#$%^&*()12"   //加密向量
private let Key : String = "ZD4417JEFFDDSCC50H3FAE3C787D0E23" //加密密钥

private let NSDATA_IV = IV.data(using: String.Encoding.utf8)
private let NSDATA_KEY = Key.data(using: String.Encoding.utf8)

class EncryptUtils {
    
    class func arrayUIntFromString(_ string: String) -> [UInt8] {
        return Array(string.utf8)
    }

    /*
    * 对输入字符串进行aes加密并输出base64字符串
    * original data -> aes -> base64
    */
    class func encrypt(_ input: String) -> String? {

        let nsdata_input = input.data(using: String.Encoding.utf8)

        if nsdata_input != nil && NSDATA_KEY != nil && NSDATA_IV != nil {

            do {
                let aes = try AES(key: Key.arrayUInt8Value, blockMode: CBC(iv: IV.arrayUInt8Value))

                let uint8_bytes_encrypted =  try aes.encrypt(nsdata_input!.bytes)
                
                let nsdata_encrypted = Data(bytes: UnsafePointer<UInt8>(uint8_bytes_encrypted), count: uint8_bytes_encrypted.count)
                return nsdata_encrypted.base64EncodedString( options: [])

            } catch {

            }

//            let aes = AES(key: Key, iv: IV, blockMode: CipherBlockMode.CBC)
//
//            let uint8_bytes_encrypted = aes?.encrypt(nsdata_input!.arrayOfBytes())
//            if uint8_bytes_encrypted != nil {
//                let nsdata_encrypted = NSData(bytes: uint8_bytes_encrypted!, length: uint8_bytes_encrypted!.count)
//                return nsdata_encrypted.base64EncodedStringWithOptions( [])
//            }
        }

        return nil
    }

    /*
    * 解密
    * base64 -> aes -> original data
    */
    class func decrypt(_ input: String) -> String? {

        let nsdata_input = Data(base64Encoded: input, options: [])

        if nsdata_input != nil && NSDATA_KEY != nil && NSDATA_IV != nil {

            do {

                let aes = try AES(key: Key.arrayUInt8Value, blockMode: CBC(iv: IV.arrayUInt8Value))
                let uint8_bytes_decrypted = try aes.decrypt(nsdata_input!.bytes)

                let nsdata_decrypted = Data(bytes: UnsafePointer<UInt8>(uint8_bytes_decrypted), count: uint8_bytes_decrypted.count)
                return String(data: nsdata_decrypted, encoding: String.Encoding.utf8)

            } catch {

            }


//            let aes = AES(key: Key, iv: IV, blockMode: CipherBlockMode.CBC)
//            let uint8_bytes_decrypted = aes?.decrypt(nsdata_input!.arrayOfBytes())
//
//            if uint8_bytes_decrypted != nil {
//                let nsdata_decrypted = NSData(bytes: uint8_bytes_decrypted!, length: uint8_bytes_decrypted!.count)
//                return NSString(data: nsdata_decrypted, encoding: NSUTF8StringEncoding) as? String
//            }
        }

        return nil
    }

    /*
    * MD5
    * original data -> md5 data
    */
    class func md5(_ input: String) -> String? {
        let strTemp = input //+ "+\(Key)"
        return strTemp.md5()
    }

    /*
    * Sign
    * 特殊签名字符串
    */
    class func sign(_ dict: [String: String]) -> String? {

        var strSign : String = ""

        for (k, v) in (dict.sorted { $0.0.uppercased() < $1.0.uppercased() }) {
            strSign += "\(k)=\(v)&"
        }
        strSign += "key=\(Key)"

        return strSign.md5()
    }

    /*
    * dict add sign
    *
    */
    class func signToDict(_ dict: inout [String: String]) -> [String: String] {

        var strSign : String = ""

        for (k, v) in (dict.sorted { $0.0.uppercased() < $1.0.uppercased() }) {
            strSign += "\(k)=\(v)&"
        }
        strSign += "key=\(Key)"

        dict["sign"] = strSign.md5()

        return dict
    }

//    /*
//    * FIXME!!!
//    * 未测试
//    */
//    class func signToDict(inout dict: [String: AnyObject]) -> [String: AnyObject] {
//
//        var strSign : String = ""
//
//        for (k, v) in (dict.sort { $0.0.uppercaseString < $1.0.uppercaseString }) {
//            var jsonString = ""
//            if v.isKindOfClass(NSArray.classForCoder()) {
//                let json = JSON(v as! NSArray)
//                jsonString = json.rawString(NSUTF8StringEncoding, options: NSJSONWritingOptions())!
//            }else if v.isKindOfClass(NSDictionary.classForCoder()) {
//                let json = JSON(v as! NSDictionary)
//                jsonString = json.rawString(NSUTF8StringEncoding, options: NSJSONWritingOptions())!
//            }else {
//                jsonString = "\(v)"
//            }
//
//            strSign += "\(k)=\(jsonString)&"
//        }
//        strSign += "key=\(Key)"
//
//        dict["sign"] = strSign.md5()
//
//        return dict
//    }

}
