//
//  ViewController.swift
//  frame
//
//  Created by yl on 16/4/25.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit
import PassKit
import SwiftQRCode

class ViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {
    @IBOutlet weak var viewMapParent: UIView!
    @IBOutlet weak var imageViewQrCode: UIImageView!
    @IBOutlet weak var textfieldAparty: UITextField!
    @IBOutlet weak var textfieldBparty: UITextField!
    @IBOutlet weak var textfieldVirtualMobile: UITextField!

    var indicator: MapCenterAnnotationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        imageViewQrCode.image = QRCode.generateImage("https://blog.csdn.net/weixin_33835690/article/details/91465632", avatarImage: UIImage(named: ""), avatarScale: 0.3)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//
//        viewBaiduMap?.frame = viewMapParent.bounds
    }

    @IBAction func onBtnClickTest(_ sender: AnyObject) {
//        if !HPLocationManager.sharedInstance.checkEnableLocation(self) {
//            return
//        }
//
//        HPLocationManager.sharedInstance.startLocation(.Always)

        NSLog("\(HPNetworkManager.sharedInstance.getNetworkLevel())")
        
        let vc = UIViewController.init()
        vc.title = "XXXXX"
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onBtnClickApplePay(_ sender: AnyObject) {

        if #available(iOS 8.0, *) {

            //兼容支付方式
            var supportedNetworks = [PKPaymentNetwork.amex, PKPaymentNetwork.masterCard, PKPaymentNetwork.visa]
            if #available(iOS 9.0, *) {
                supportedNetworks.append(PKPaymentNetwork.discover)
                supportedNetworks.append(PKPaymentNetwork.privateLabel)
            }
            if #available(iOS 9.2, *) {
                supportedNetworks.append(PKPaymentNetwork.chinaUnionPay)
                supportedNetworks.append(PKPaymentNetwork.interac)
            }
            if !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedNetworks) {
                NSLog("当前不支持您的ApplePay付款方式")
                return
            }

            if PKPaymentAuthorizationViewController.canMakePayments() {
                let payRequest = PKPaymentRequest()
                payRequest.countryCode = "CN"
                payRequest.currencyCode = "CNY"
                payRequest.supportedNetworks = supportedNetworks
                payRequest.merchantCapabilities = .capabilityEMV
                payRequest.merchantIdentifier = "merchant.com.homepaas.merchanttest"

                let itemPay = PKPaymentSummaryItem(label: "Item", amount: NSDecimalNumber(string: "0.01"))
                let totalPay = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: "0.01"))
                payRequest.paymentSummaryItems = [itemPay, totalPay]

                let paymentViewController = PKPaymentAuthorizationViewController(paymentRequest: payRequest)
                paymentViewController?.delegate = self
                if nil != paymentViewController {
                    self.present(paymentViewController!, animated: true) {

                    }
                }
            }
        }else {
            NSLog("版本太低")
            return
        }

    }

    @available(iOS 8.0, *)
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        _ = payment.token


        completion(PKPaymentAuthorizationStatus.success)
    }

    @available(iOS 8.0, *)
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true) {

        }
    }
    @IBAction func onBtnClickBind(_ sender: AnyObject) {
//        MCEntity.sharedInstance.bindMixComTrumpet(textfieldAparty.text!, bparty: textfieldBparty.text!, virtualMobile: textfieldVirtualMobile.text!)
    }
    @IBAction func onBtnClickUnbind(_ sender: AnyObject) {
//        MCEntity.sharedInstance.unbindMixcomTrumpet(textfieldAparty.text!, bparty: textfieldBparty.text!, virtualMobile: textfieldVirtualMobile.text!)
    }
    @IBAction func onBtnClickStartAnimating(_ sender: UIButton) {
//        viewAnimation.startAnimating(true)
        indicator = MapCenterAnnotationView.showAnnotationViewAbove(self.view, position: self.view.center)
    }
    @IBAction func onBtnClickEndAmiating(_ sender: UIButton) {
//        viewAnimation.stopAnimating(true)
        indicator?.showAddress("迪凯国际中心")
    }
    @IBAction func onBtnClickRemoveAnimation(_ sender: AnyObject) {
        indicator?.removeFromSuperview()
    }

    @IBAction func onBtnClickAddAnnotation(_ sender: AnyObject) {

    }
    @IBAction func onBtnClickRemoveAnnotation(_ sender: AnyObject) {
    }

    @IBAction func onBtnClickPresent(_ sender: AnyObject) {
//        ActivityViewController.present(self)
        HBLoadingView.show()
    }
    
    @objc func test() {
        HBLoadingView.show()
    }
    
}

