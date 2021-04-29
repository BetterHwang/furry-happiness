//
//  MCEntity.swift
//  frame
//
//  Created by yl on 16/8/12.
//  Copyright © 2016年 yl. All rights reserved.
//

import Foundation
//import SwiftyJSON
//
//class MCEntity {
//    let APP_KEY = "33a4d1411ca79c1a4c43465f97552751"
//    let APP_SECRET = "dR2Ldb"
//    let BASE_URL = "http://api.mixcaller.com/?m=interfaces&c=virt&a=index"
//
//    static let _inst = MCEntity()
//    class var sharedInstance: MCEntity {
//        return _inst
//    }
//
//    fileprivate init() {
//
//    }
//
//    func bindMixComTrumpet(_ aparty: String, bparty: String, virtualMobile: String = "17092580727") {
//        let time = Date().timeIntervalSince1970.toString("%.0llf")
//
//        var urlString = BASE_URL
//        urlString += "&act=bindnumber"
//        urlString += "&appkey=" + APP_KEY
//        urlString += "&sign=" + EncryptUtils.md5(APP_KEY + "interfaces" + "virt" + "bindnumber" + "86\(virtualMobile)" + "86\(aparty)" + "86\(bparty)" + APP_SECRET + time)!//EncryptUtils.md5("appkey=" + APP_KEY + "m=interfaces" + "c=virt" + "act=bindnumber" + "virtualnumber=8617080062201" + "apart=8613026603914" + "bpart=8613632744853" + "appSecret=" + APP_SECRET + "time=" + time)!
//        urlString += "&time=" + time
//        urlString += "&virtualnumber=" + "86\(virtualMobile)"
//        urlString += "&aparty=" + "86\(aparty)"
//        urlString += "&bparty=" + "86\(bparty)"
//
//        let request = NSMutableURLRequest(url: URL(string: urlString)!)
//        request.httpMethod = "POST"
//        NSLog("\(urlString)")
//        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main, completionHandler: { (response: URLResponse?, data: Data?, error: NSError?) -> Void in
//            if nil != error {
//                NSLog("申请小号绑定返回错误：\(error!.localizedDescription)")
//                return
//            }
//
//            if nil != data {
//                let dataJson = JSON(data: data!)
//                if dataJson["statusCode"] == "200" {
//                    let dataString = String(data: data!, encoding: String.Encoding.utf8)
//                    NSLog("\(dataString)")
//                    UIAlertView(title: "绑定成功", message: "", delegate: nil, cancelButtonTitle: "确定").show()
//                }
////                let dataString = String(data: data!, encoding: NSUTF8StringEncoding)
////                NSLog("\(dataString)")
////                UIAlertView(title: "绑定成功", message: "", delegate: nil, cancelButtonTitle: "确定").show()
//            }
//        } as! (URLResponse?, Data?, Error?) -> Void)
//    }
//
//    func unbindMixcomTrumpet(_ aparty: String, bparty: String, virtualMobile: String = "17092580727") {
//        let time = Date().timeIntervalSince1970.toString("%.0llf")
//
//        var urlString = BASE_URL
//        urlString += "&act=unbindnumber"
//        urlString += "&appkey=" + APP_KEY
//        urlString += "&sign=" + EncryptUtils.md5(APP_KEY + "interfaces" + "virt" + "unbindnumber" + "86\(virtualMobile)" + APP_SECRET + time)!//EncryptUtils.md5("appkey=" + APP_KEY + "m=interfaces" + "c=virt" + "act=unbindnumber" + "virtualnumber=8617080062201" + "apart=8613026603914" + "bpart=8613632744853" + "appSecret=" + APP_SECRET + "time=" + time)!
//        urlString += "&time=" + time
//        urlString += "&virtualnumber=" + "86\(virtualMobile)"
//        if 0 < aparty.length && 0 < bparty.length  {
//            urlString += "&aparty=" + "86\(aparty)"
//            urlString += "&bparty=" + "86\(bparty)"
//        }
//
//        let request = NSMutableURLRequest(url: URL(string: urlString)!)
//        request.httpMethod = "POST"
//        NSLog("\(urlString)")
//
//        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main, completionHandler: { (response: URLResponse?, data: Data?, error: NSError?) -> Void in
//            if nil != error {
//                NSLog("申请小号绑定返回错误：\(error!.localizedDescription)")
//                return
//            }
//
//            if nil != data {
//                let dataJson = JSON(data: data!)
//                if dataJson["statusCode"] == "200" {
//                    let dataString = String(data: data!, encoding: String.Encoding.utf8)
//                    NSLog("\(dataString)")
//                    UIAlertView(title: "绑定成功", message: "", delegate: nil, cancelButtonTitle: "确定").show()
//                }
////                let dataString = String(data: data!, encoding: NSUTF8StringEncoding)
////                NSLog("\(dataString)")
////                UIAlertView(title: "绑定成功", message: "", delegate: nil, cancelButtonTitle: "确定").show()
//            }
//        } as! (URLResponse?, Data?, Error?) -> Void)
//    }
//}
