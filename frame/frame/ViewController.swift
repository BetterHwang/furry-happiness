//
//  ViewController.swift
//  frame
//
//  Created by yl on 16/4/25.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit
import PassKit
//import SwiftQRCode

class ViewController: UIViewController {
    
    lazy var applePayHander: ApplePayHander = {
        let handle = ApplePayHander()
        return handle
    }()
    
    private var _appleLoginHandler: Any? = nil
    @available(iOS 13.0, *)
    var appleLoginHandler: AppleLoginHandler? {
        set {
            _appleLoginHandler = newValue
        }
        get {
             return _appleLoginHandler as? AppleLoginHandler
        }
    }
//    lazy var appleLoginHandler: AppleLoginHandler = {
//        let handler = AppleLoginHandler()
//        return handler
//    }()
    
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
        
//        imageViewQrCode.image = QRCode.generateImage("https://blog.csdn.net/weixin_33835690/article/details/91465632", avatarImage: UIImage(named: ""), avatarScale: 0.3)
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
        
        if #available(iOS 13.0, *) {
            appleLoginHandler = AppleLoginHandler()
            appleLoginHandler?.request(viewController: self)
        } else {
            // Fallback on earlier versions
        }
//        applePayHander.requst(viewController: self)
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

