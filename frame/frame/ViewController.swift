//
//  ViewController.swift
//  frame
//
//  Created by yl on 16/4/25.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit
import PassKit

class ViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate, BMKMapViewDelegate {
    @IBOutlet weak var viewMapParent: UIView!
    @IBOutlet weak var imageViewQrCode: UIImageView!
    @IBOutlet weak var textfieldAparty: UITextField!
    @IBOutlet weak var textfieldBparty: UITextField!
    @IBOutlet weak var textfieldVirtualMobile: UITextField!

    var indicator: MapCenterAnnotationView?
    var viewBaiduMap: BMKMapView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        imageViewQrCode.image = QRCodeGenerator.qrImageForString("http://www.baidu.com/", imageSize: 80)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        mapCreate()
//        viewBaiduMap?.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

//        viewBaiduMap?.viewWillDisappear()
//        mapDestory()

    }

    func mapCreate() {

        //初始化地图
        viewBaiduMap = BMKMapView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 109))
        viewBaiduMap?.mapType = BMKMapType.standard
        viewBaiduMap?.showMapScaleBar = true
        viewBaiduMap?.mapScaleBarPosition = CGPoint(x: 55, y: UIScreen.main.bounds.height - 64 - 88)
        viewBaiduMap?.isSelectedAnnotationViewFront = true
        viewBaiduMap?.userTrackingMode = BMKUserTrackingModeNone
        let param = BMKLocationViewDisplayParam()
        param.isAccuracyCircleShow = false
        viewBaiduMap?.updateLocationView(with: param)
        viewBaiduMap?.showsUserLocation = true
        viewBaiduMap?.zoomLevel = Float(17)

        if nil != viewBaiduMap {
            viewMapParent?.addSubview(viewBaiduMap!)
        }

        viewBaiduMap?.delegate = self
        //添加百度定位监听
    }

    func mapDestory() {

        //删除百度定位监听
        viewBaiduMap?.delegate = nil
        viewBaiduMap?.removeFromSuperview()
        viewBaiduMap = nil
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

        let annotation = BMKPAnnotationBase()
        annotation.title = "实施"
        annotation.subtitle = "(1)"
        annotation.coordinate = viewBaiduMap!.centerCoordinate
        viewBaiduMap?.addAnnotation(annotation)
    }
    @IBAction func onBtnClickRemoveAnnotation(_ sender: AnyObject) {
        viewBaiduMap?.removeAnnotations(viewBaiduMap?.annotations)
    }

    @IBAction func onBtnClickPresent(_ sender: AnyObject) {
        ActivityViewController.present(self)
    }
    //地图返回
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if nil != annotation && annotation.isKind(of: BMKPAnnotationBase.classForCoder()) {

            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MapServicePointAnnotationView") as? MapServicePointAnnotationView

            if nil == annotationView {
                annotationView = MapServicePointAnnotationView(annotation: annotation as! BMKPAnnotationBase, identifier: "MapServicePointAnnotationView")
            }

            //            let annotationView = ServicePointAnnotationView()
            annotationView?.annotationServicePoint =  annotation as? BMKPAnnotationBase
            return annotationView

        }

        return nil
    }

    func mapView(_ mapView: BMKMapView!, didSelect view: BMKAnnotationView!) {
        let annotations = mapView.annotations

        for itemAnnotation in annotations! {
            if let annotationView = mapView.view(for: itemAnnotation as! BMKAnnotation) as? MapServicePointAnnotationView {
                annotationView.showBadge(8)
            }
        }
    }
}

