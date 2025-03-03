//
//  AppleIAPHandler.swift
//  frame
//
//  Created by East on 2025/3/3.
//  Copyright © 2025 yl. All rights reserved.
//

import Foundation
import StoreKit
//import HandyJSON

class YGApplePurchaseService: NSObject,SKPaymentTransactionObserver,SKProductsRequestDelegate {
    
    static var instance = YGApplePurchaseService()
//    var paymentObj : YGArtCoinModel?
    var currentProductId:String = ""
    var purchaseQuantity:Int!
    
    private var callback_ret: ((Bool, String)-> Void)?
    
//    //沙盒测试环境验证
//    let SANDBOX  = "https://sandbox.itunes.apple.com/verifyReceipt"
//
//    //正式环境验证
//    let AppStore = "https://buy.itunes.apple.com/verifyReceipt"
//
//    var hud:YKProgressHUD!

    private override init() {
        super.init()
        
    }
    
    func requestProducts(productIDs: [String]) {
        
        let requestProducts = SKProductsRequest(productIdentifiers: Set(productIDs))
        requestProducts.delegate = self
        requestProducts.start()
    }
    
    func purchase(productId:String, quantity:Int, callback: @escaping (Bool, String)-> Void) {
        print(productId)
        self.callback_ret = callback
        //每次只允许一次支付，这里不再做重复性判断
//        self.paymentObj = paymentObj
        //,isPurchase == false
        guard SKPaymentQueue.canMakePayments() else {
            return
        }
        //        isPurchase = true
        SKPaymentQueue.default().add(self)
        currentProductId = productId
        purchaseQuantity = quantity
        let productsRequest = SKProductsRequest(productIdentifiers: Set([productId]))
        productsRequest.delegate = self
        productsRequest.start()
        
//        hud = YKProgressHUD.show()
    }
    
    
    //监听结果
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for trans in transactions {
            switch trans.transactionState {
            case .purchasing:
                //购买中
                print("购买中")
                break
            case .purchased:
                //交易完成
                verifyTransactionResult(transactions: trans)
                SKPaymentQueue.default().finishTransaction(trans)
                break
            case .restored:
                //已经购买过商品
                SKPaymentQueue.default().finishTransaction(trans)
                break
            case .failed:
                //交易失败
                SKPaymentQueue.default().finishTransaction(trans)
                
                let errStr = errorReason(error: trans.error)
                DispatchQueue.main.async { [weak self] in
                    //code
                    self?.callback_ret?(false, errStr)
//                    self?.hud?.hide(animated: true)
                }
                break
            default:
                break
            }
        }
    }
    
    //接收到产品的返回信息,然后用返回的商品信息进行发起购买请求
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("[NirvanaStoreKit.productsRequest]")
        
        let products = response.products
        
        // check if request product info failed.
        // 如果服务器没有产品
        if (products.count == 0){
            
            print("request product info failed. ")
            
            let invalidProductIdentifiers = response.invalidProductIdentifiers
            for product in invalidProductIdentifiers {
                print("invaild product ", product)
            }
            
            DispatchQueue.main.async { [weak self] in
                //code
//                YKProgressHUD.show("交易失败：无效商品")
//                self?.hud?.hide(animated: true)
            }
            return
        }
        
        // request product info success
        print("request product info success")
        
        //
        var paymentProduct:SKProduct? = nil
        for product in products {
            print("description=\(product.description), localizedTitle=\(product.localizedTitle), localizedDescription=\(product.localizedDescription), price=\(product.price), productIdentifier=\(product.productIdentifier)")
            
            if product.productIdentifier == self.currentProductId {
                paymentProduct = product
            }
        }
        
        if paymentProduct == nil {
            print("not find match product identifier.")
            DispatchQueue.main.async { [weak self] in
                //code
//                self?.hud?.hide(animated: true)
            }

            return
        }
        
        // request buy
        //发送购买请求
        let payment = SKMutablePayment(product: paymentProduct!)
        payment.quantity = purchaseQuantity
        payment.applicationUsername = ""//UserManager.sharedInstance.getUser().customerid
//        payment.requestData = nil
        print("request payment")
        SKPaymentQueue.default().add(payment)
    }
    
    func requestDidFinish(_ request: SKRequest) {
        //购买结束
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        let errStr = self.errorReason(error: error)
        DispatchQueue.main.async { [weak self] in
            //code
            self?.callback_ret?(false, errStr)
//            self?.hud.hide(animated: true)
        }
    }
    
    //交易完成二次校验
    func verifyTransactionResult(transactions : SKPaymentTransaction) {
        // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
        // 从沙盒中获取到购买凭据
        var parameters : [String : Any] = [String : Any]()
        
        if let url = Bundle.main.appStoreReceiptURL, let recriptData = NSData.init(contentsOf: url) {
            let encodeStr = recriptData.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
            parameters["transactionReceipt"] = encodeStr
        }else {
            parameters["transactionReceipt"] = "未获得AppStore购买凭证！"
        }
        parameters["transactionId"] = transactions.transactionIdentifier
        parameters["customerid"] = ""//UserManager.sharedInstance.userInfo?.customerid
        parameters["thirdskuid"] = transactions.payment.productIdentifier
        
        DispatchQueue.main.async { [weak self] in
            self?.createArtCoinOrder(parameters: parameters)
        }
    }
    
    func errorReason(error: Error?) -> String {
        guard let error = error else {
            return ""
        }
        
        let skError = SKError.init(_nsError: error as NSError)
        
        switch skError {
        case SKError.clientInvalid:
            return "客户端异常"
        case SKError.paymentCancelled:
            return "用户取消支付"
        case SKError.paymentInvalid:
            return "参数异常"
        case SKError.storeProductNotAvailable:
            return "无效商品"
        default:
            return skError.localizedDescription
        }
    }
    
    func createArtCoinOrder(parameters : [String : Any]){
//        BaseNet.post(with: APPURL.createGoldPoints, parameters: parameters) { [weak self] (json, string, data, request, response) in
//
//            guard let model : YGApplePurchaseResultModel = JSONDeserializer<YGApplePurchaseResultModel>.deserializeFrom(dict: json as? [String : Any]) else {
//                
//                DispatchQueue.main.async {
//                    self?.callback_ret?(false, "JSON解析失败")
//                    self?.hud?.hide(animated: true)
//                }
//                return
//            }
//            
//            //交易成功删除缓存
//            if model.rtncode == 1{
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: APPKEY.NOTIFICATION_RECHARGE_SUCCESS), object: nil)
//                self?.remove()
//                DispatchQueue.main.async {
//                    self?.callback_ret?(true, "")
//                    self?.hud?.hide(animated: true)
//                }
//            }else{
//                

//                
//                DispatchQueue.main.async {
//                    self?.callback_ret?(false, "JSON返回错误")
//                    self?.hud?.hide(animated: true)
//                }
//            }
//        } failure: { [weak self] (error) in
//            let errStr = error?.localizedDescription ?? ""
//            DispatchQueue.main.async {
//                //code
//                self?.callback_ret?(false, "\(errStr)")
//                self?.hud?.hide(animated: true)
//            }
//        }
    }
    
    func save(params: [String: Any]) {
        let userDefaults = UserDefaults.standard

        var dic : [String : Any] = [String : Any]()
        dic["transactionReceipt"] = params["transactionReceipt"]
        dic["transactionId"] = params["transactionId"]
        dic["customerid"] = params["customerid"]
        dic["thirdskuid"] = params["thirdskuid"]
        userDefaults.setValue(dic, forKey: "APPLEPURCHASE")
        userDefaults.synchronize()
    }
    
    func remove(){
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "APPLEPURCHASE")
        userDefaults.synchronize()
    }
}
