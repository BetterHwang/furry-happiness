//
//  ApplePayHander.swift
//  frame
//
//  Created by East on 2025/2/28.
//  Copyright © 2025 yl. All rights reserved.
//

import Foundation
import PassKit

class ApplePayHander: NSObject, PKPaymentAuthorizationViewControllerDelegate {
    
    lazy var supportedNetworks: [PKPaymentNetwork] = {
        var list = [PKPaymentNetwork.amex, PKPaymentNetwork.masterCard, PKPaymentNetwork.visa]
        if #available(iOS 9.0, *) {
            list.append(PKPaymentNetwork.discover)
            list.append(PKPaymentNetwork.privateLabel)
        }
        if #available(iOS 9.2, *) {
            list.append(PKPaymentNetwork.chinaUnionPay)
            list.append(PKPaymentNetwork.interac)
        }
        
        return list
    }()
    
    func canUsed() -> Bool {
        
        //兼容支付方式
        if !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedNetworks) {
            NSLog("当前不支持您的ApplePay付款方式")
            return false
        }
        
        return PKPaymentAuthorizationViewController.canMakePayments()
    }
    
    func requst(viewController: UIViewController) {
        
        //兼容支付方式
        
        let payRequest = PKPaymentRequest()
        payRequest.countryCode = "CN"
        payRequest.currencyCode = "CNY"
        payRequest.supportedNetworks = supportedNetworks
        payRequest.merchantCapabilities = .capabilityEMV
        payRequest.merchantIdentifier = "merchant.com.homepaas.merchanttest"
        
        let itemPay = PKPaymentSummaryItem(label: "Item", amount: NSDecimalNumber(string: "0.01"))
        let totalPay = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: "0.01"))
        payRequest.paymentSummaryItems = [itemPay, totalPay]
        
        guard let paymentViewController = PKPaymentAuthorizationViewController(paymentRequest: payRequest) else {
            return
        }
        
        paymentViewController.delegate = self
        viewController.present(paymentViewController, animated: true) {

        }
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        _ = payment.token
        // 校验

        completion(PKPaymentAuthorizationStatus.success)
    }

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true) {

        }
    }
}
