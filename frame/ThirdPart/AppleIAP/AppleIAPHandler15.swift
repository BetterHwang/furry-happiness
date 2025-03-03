//
//  AppleIAPHandler15.swift
//  frame
//
//  Created by East on 2025/3/3.
//  Copyright © 2025 yl. All rights reserved.
//

import Foundation

import StoreKit
//import CommonCrypto
import CryptoSwift

@available(iOS 15.0, *)
class YGApplePurchaseService15: NSObject {
    private(set) var products: [Product] = []
    
    static let instance = YGApplePurchaseService15()
    
//    var hud: YKProgressHUD?
    
    override init() {
        super.init()
        
        /// 防掉单处理
        listenTransactionState()
    }
    
    @MainActor
    /// 通过 productIds 请求 Product 列表
    /// - Parameter productIds: product ids
    /// - Returns: Product 列表
    func requestProducts(productId: String) async {
        DispatchQueue.main.async { [weak self] in
//            self?.hud = YKProgressHUD.show()
        }
        do {
            products = try await Product.products(for: [productId])
            guard let product = products.first else {
                return
            }
            let _ = try await purchase(product: product)
        } catch {
            products = []
        }
    }
    
    /// 发起支付
    /// - Parameter product: Product对象
    public func purchase(product: Product) async throws {
        //App account token
        //用于将用户 ID 绑定到交易（Transcation）中，即可建立苹果的交易订单数据与用户信息的映射关系，方便数据整合与追溯
        var options = Set<Product.PurchaseOption>()
        
        let userUUID = Self.getUserUUID()
        guard !userUUID.isEmpty, let uuid = UUID(uuidString: userUUID) else {
            DispatchQueue.main.async { [weak self] in
//                self?.hud?.hide(animated: true)
//                YKProgressHUD.show("用户识别码字段错误。")
            }
            return
        }
        
        let optionUUID_Cust = Product.PurchaseOption.appAccountToken(uuid)
        options.insert(optionUUID_Cust)
        
        //发起支付流程
        let result = try? await product.purchase(options: options)
        
        //        var validateTransaction: Transaction? = nil
        
//        if (nil != self.hud) {
//            DispatchQueue.main.async { [weak self] in
//                self?.hud?.hide(animated: true)
//            }
//        }
        
        switch result {
        case .success(let verificationResult):
            //购买状态：成功
            
            print("用户购买成功")
            
            if case .verified(let transaction) = verificationResult {
                //结束交易
                //                validateTransaction = transaction
                DispatchQueue.main.async { [weak self] in
                    self?.onTransactionSucceed(transaction: transaction)
                }
                
//                await transaction.finish()
            }
            
        case .userCancelled:
            //购买状态：用户取消
            print("用户取消购买")
            
        case .pending:
            //购买状态：进行中
            print("用户购买中")
            
        default:
            //购买状态：未知
            print("用户购买状态：未知")
        }
        
        //        return validateTransaction
    }
    
    private func listenTransactionState() {
        Task.detached { [weak self] in
            for await verificationResult in Transaction.updates {
                if case .verified(let transaction) = verificationResult {
                    //在这里给服务器上传transaction.id、transaction.originalID服务器就可以去苹果服务器请求订单信息了。
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.onTransactionSucceed(transaction: transaction)
                    }
//                    await transaction.finish()
                }
            }
        }
    }
    
    private func onTransactionSucceed(transaction: Transaction) {
        var params = [String: Any]()
        
        //decode base64
        let data = transaction.jsonRepresentation//.base64EncodedData()
        var encrypted: [UInt8] = []
        do {
            encrypted = try AES(key: Array(AppConstants.AES_KEY.utf8), blockMode: CBC(iv: Array(AppConstants.AES_IV.utf8)), padding: .zeroPadding).encrypt(data.bytes);
        } catch {
            print(error.localizedDescription)
        }
        
        let encryptedStr = encrypted.toBase64()
        
        params["transactionReceipt"] = encryptedStr
        params["transactionId"] = "\(transaction.id)"
        params["thirdskuid"] = "\(transaction.productID)"
        
        Task {
            await transaction.finish()
        }
//        guard UserManager.sharedInstance.isLoginSuccess() else {
//            return
//        }
        
//        BaseNet.post(with: APPURL.createGoldPoints_v2, parameters: params) { model in
//            
//            if 1 == model.rtncode {
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: APPKEY.NOTIFICATION_RECHARGE_SUCCESS), object: nil)
//                
//                DispatchQueue.main.async {
//                    YKProgressHUD.show("充值成功")
//                }
//            }else {
//                DispatchQueue.main.async {
//                    YKProgressHUD.show(model.rtnmsg)
//                }
//            }
//            
//            Task {
//                await transaction.finish()
//            }
//        } failed: { error in
//            DispatchQueue.main.async {
//                YKProgressHUD.show(error?.localizedDescription ?? "")
//            }
//        }
    }
    
    @MainActor
    /// 发起退款
    /// - Parameters:
    ///   - transactionId: transaction.originalID
    ///   - scene: Window scene
    public func refundRequest(transactionID: UInt64, scene: UIWindowScene!) async {
        do {
            let result = try await Transaction.beginRefundRequest(for: transactionID, in: scene)
            switch result {
            case .success:
                print("退款提交成功。")
                // Refund request was successfully submitted.
            case .userCancelled:
                // Customer cancelled refund request.
                print("用户取消退款。")
            @unknown default:
                print("退款返回错误：未知")
            }
        }
        catch StoreKit.Transaction.RefundRequestError.duplicateRequest {
            print("退款请求错误：重复请求")
        }
        catch StoreKit.Transaction.RefundRequestError.failed {
            print("退款请求错误：失败")
        }
        catch {
            print("退款请求错误：其他")
        }
    }
    
    static func getUserUUID() -> String {
//        let userUUID = UserManager.sharedInstance.getUser().custuuid
//        if !userUUID.isEmpty {
//            return userUUID
//        }
        
        return ""
//        let uuid = UUID()
//        userUUID = uuid.uuidString
//        UserManager.sharedInstance.getUser().uuid = userUUID
        
//        var params =  [String: Any]()
//        params[""] = userUUID
//        BaseNet.post(with: APPURL.bravo, parameters: params) { model in
//
//        } failed: { error in
//
//        }

//        return userUUID
    }
}
