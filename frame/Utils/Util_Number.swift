//
//  Util_Number.swift
//  frame
//
//  Created by apple on 2021/5/6.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation

class Util_Number {
    static func isTelNumber(tel: String) -> Bool {
        var bRet = false
        
        // 验证输入的固话中带 "-"符号
        var strNum = "^(0\\d{2,3}-?\\d{7,8}$)"
        var check = NSPredicate.init(format: "SELF MATCHES \(strNum)")
        bRet = check.evaluate(with: tel)
        if bRet {
            return bRet
        }
        
        // 验证输入的固话中不带 "-"符号
        strNum = "^(\\d{7,8}$)"
        check = NSPredicate.init(format: "SELF MATCHES \(strNum)")
        bRet = check.evaluate(with: tel)
        if bRet {
            return bRet
        }
        
        return bRet
    }
    
    static func isMobileNumber(mobile: String) -> (Bool, String) {
        var bRet = false
        
        var temp = mobile.replacingOccurrences(of: "-", with: "")
        temp = temp.replacingOccurrences(of: " ", with: "")
        
        if 11 != temp.count {
            return (false, "数字数量不太对\(temp.count)")
        }
        
        //移动
        var strNum = "^1(34[0-8]|3[4-9]|47|5[0127-9]|7[28]|8[23478]|98)\\d{8}$"
        var check = NSPredicate.init(format: "SELF MATCHES \(strNum)")
        bRet = check.evaluate(with: temp)
        if bRet {
            return (bRet, "中国移动")
        }
        
        //联通
        strNum = "^1((3[0-2]|45|5[56]|166|7[56]|8[56]))\\d{8}$"
        check = NSPredicate.init(format: "SELF MATCHES \(strNum)")
        bRet = check.evaluate(with: temp)
        if bRet {
            return (bRet, "中国联通")
        }
        
        //电信
        strNum = "^1((3[0-2]|45|5[56]|166|7[56]|8[56]))\\d{8}$"
        check = NSPredicate.init(format: "SELF MATCHES \(strNum)")
        bRet = check.evaluate(with: temp)
        if bRet {
            return (bRet, "中国电信")
        }
        
        return (bRet, "格式不对")
    }
    
    static func isIdCard(idCard: String) -> Bool {
        let temp = idCard.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if 15 != temp.count && 18 != temp.count {
            return false
        }
        
        return true
    }
    
    static func isIdCardValid(idCard: String) -> Bool {
        let temp = idCard.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if 15 != temp.count && 18 != temp.count {
            return false
        }
        
        // 省份代码
        let areasArray = ["11", "12", "13", "14", "15", "21", "22", "23", "31", "32", "33", "34", "35", "36", "37", "41", "42", "43", "44", "45", "46", "50", "51", "52", "53", "54", "61", "62", "63", "64", "65", "71", "81", "82", "91"]
        var indexStart = temp.startIndex
        var indexEnd = temp.index(indexStart, offsetBy: 2)
        let area = String(temp[indexStart ..< indexEnd])
        
        if nil == areasArray.firstIndex(of: area) {
            return false
        }
        
        //fix me
        var check: NSRegularExpression?
        
        indexStart = temp.index(temp.startIndex, offsetBy: 2)
        if 15 == temp.count {
            indexEnd = temp.index(temp.startIndex, offsetBy: 2 + 2)
            let year = String(temp[indexStart ..< indexEnd]).intValue + 1900
            
            if isYearLeap(year: year) {
                do {
                    check = try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: .caseInsensitive)
                } catch let error {
                    print(error.localizedDescription)
                }
            }else {
                do {
                    check = try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: .caseInsensitive)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            
            if nil == check {
                return false
            }
            
            return 0 < check!.numberOfMatches(in: temp, options: .reportProgress, range: NSRange(location: 0, length: temp.count))
        }else if 18 == temp.count {
            indexEnd = temp.index(temp.startIndex, offsetBy: 2 + 4)
            let year = String(temp[indexStart ..< indexEnd]).intValue
            
            if isYearLeap(year: year) {
                do {
                    check = try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}19|20[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive)
                } catch let error {
                    print(error.localizedDescription)
                }
            }else {
                do {
                    check = try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}19|20[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$", options: .caseInsensitive)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            
            if nil == check {
                return false
            }
            
            let numberOfMatch = check!.numberOfMatches(in: temp, options: .reportProgress, range: NSRange(location: 0, length: temp.count))
            if 0 >= numberOfMatch {
                return false
            }
            let sum = temp.substring(start: 0, length: 1).intValue + temp.substring(start: 10, length: 1).intValue * 7 + temp.substring(start: 1, length: 1).intValue + temp.substring(start: 11, length: 1).intValue * 9 + temp.substring(start: 2, length: 1).intValue + temp.substring(start: 12, length: 1).intValue * 10 + temp.substring(start: 3, length: 1).intValue + temp.substring(start: 13, length: 1).intValue * 5 + temp.substring(start: 4, length: 1).intValue + temp.substring(start: 14, length: 1).intValue * 8 + temp.substring(start: 5, length: 1).intValue + temp.substring(start: 15, length: 1).intValue * 4 + temp.substring(start: 6, length: 1).intValue + temp.substring(start: 16, length: 1).intValue * 2 + temp.substring(start: 7, length: 1).intValue + temp.substring(start: 8, length: 1).intValue * 6 + temp.substring(start: 9, length: 1).intValue * 3
            let y = sum % 11
            var M = "F"
            let JYM = "10X98765432"
            M = JYM.substring(start: y, length: 1)
            if M != temp.substring(start: 17, length: 1).uppercased() {
                return false
            }
        }
        
        return true
    }
    
    static func isYearLeap(year: Int) -> Bool {
        //能被4整除 不能被100整除 能被400整除
        if (0 == year % 4 && 0 != year % 100) || 0 == year % 400 {
            return true
        }
        
        return false
    }
}
