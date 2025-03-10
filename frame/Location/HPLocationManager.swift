//
//  HPLocationManager.swift
//  frame
//
//  Created by yl on 16/4/25.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

@objc protocol HPLocationManagerDelegate: NSObjectProtocol {
    @objc optional func locationManagerWillStartLocation(_ style: LocationStyle)
    @objc optional func locationManagerDidStopLocation()
    @objc optional func locationManagerDidUpdateLocationGPS(_ location: CLLocation?, placeMark: CLPlacemark?)
    @objc optional func locationManagerUpdateLocationError(_ error: NSError?)
    @objc optional func locationManagerDidEnterBackGround()
    @objc optional func locationManagerWillEnterForeGround()
}

class Weak<T: NSObjectProtocol> {
    weak var value: T?
    init(value: T) {
        self.value = value
    }
}

@objc enum LocationStyle: Int {
    case always
    case inUsage
}

private typealias CallBackLocationManagerEnterBackground = () -> Void
private typealias CallBackLocationManagerEnterForeground = () -> Void

private let defaultLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)

class HPLocationManager: NSObject, CLLocationManagerDelegate {
    
    fileprivate var manageForSystem: CLLocationManager = CLLocationManager()
    
    static let sharedInstance = HPLocationManager()
    
    fileprivate var _callbackCloseLocation: (() -> Void)?
    fileprivate var _currentLocation: CLLocationCoordinate2D = defaultLocation
    
    fileprivate var listDelegate = [Weak<HPLocationManagerDelegate>]()
    
    fileprivate override init() {
        super.init()
        
        //定位用途 影响是否自动暂停定位
        manageForSystem.activityType = .automotiveNavigation
        //距离移动更新 最小值
        manageForSystem.distanceFilter = kCLDistanceFilterNone
        //精确度 最小值
        manageForSystem.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //转动角度更新 最小值
        manageForSystem.headingFilter = 1
        //设备方向
        manageForSystem.headingOrientation = .portrait
        manageForSystem.delegate = self
        
        //app进入前后台事件

        NotificationCenter.default.addObserver(self, selector: #selector(HPLocationManager.appDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HPLocationManager.appWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HPLocationManager.appWillTerminate(_:)), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    @objc func appDidEnterBackground(_ notice: Notification) {
        //已经进入后台协议
        for delegateItem in listDelegate {
            delegateItem.value?.locationManagerDidEnterBackGround?()
        }
    }
    
    @objc func appWillEnterForeground(_ notice: Notification) {
        //进入前台前调用协议
        for delegateItem in listDelegate {
            delegateItem.value?.locationManagerWillEnterForeGround?()
        }
    }
    
    @objc func appWillTerminate(_ notice: Notification) {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willTerminateNotification, object: nil)
    }
    
    func startLocation(_ style: LocationStyle, callbackCloseLocation: (() -> Void)? = nil) {
        _callbackCloseLocation = callbackCloseLocation
        
        if !enableLocation() {
            let alert = UIAlertController.init(title: "温馨提示", message: "系统定位服务被关闭，请到设置中设置", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
                //goto 设置
                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            }))
            alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
            return
        }
        
        switch style {
        case .always:
            //永久使用
            if #available(iOS 8.0, *) {
                if (self.manageForSystem.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization))) {
                    self.manageForSystem.requestAlwaysAuthorization()
                }
            } else {
                // Fallback on earlier versions
            }
            
            //background保持定位
            if #available(iOS 9.0, *) {
                manageForSystem.allowsBackgroundLocationUpdates = true
            } else {
                // Fallback on earlier versions
            }
            
            //pausesLocationUpdatesAutomatically为false && capabilities->Background Modes->Location Updates 勾选
            //动态暂停关闭
            self.manageForSystem.pausesLocationUpdatesAutomatically = false
            
            //即将开启定位协议
            for delegateItem in listDelegate {
                delegateItem.value?.locationManagerWillStartLocation?(.always)
            }
            break
        case .inUsage:
            //使用时开启
            if #available(iOS 8.0, *) {
                if (self.manageForSystem.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))) {
                    self.manageForSystem.requestWhenInUseAuthorization()
                }
            } else {
                // Fallback on earlier versions
            }
            
            //即将开启定位协议
            for delegateItem in listDelegate {
                delegateItem.value?.locationManagerWillStartLocation?(.inUsage)
            }
            break
        }
        
        
        //开始定位
        manageForSystem.startUpdatingLocation()
    }
    
    func stopLocation() {
        manageForSystem.stopUpdatingLocation()
        
        //已经关闭定位协议
        for delegateItem in listDelegate {
            delegateItem.value?.locationManagerDidStopLocation?()
        }
    }
    
    func addDelegate(_ delegate: HPLocationManagerDelegate) {
        // 判断是否已存在
        let index = listDelegate.firstIndex {
            nil != $0.value && $0.value!.isEqual(delegate)
        }
        
        if nil == index {
            listDelegate.append(Weak<HPLocationManagerDelegate>.init(value: delegate))
        }
    }
    
    func removeDelegate(_ delegate: HPLocationManagerDelegate) {
        listDelegate.removeAll {
            nil != $0.value && $0.value!.isEqual(delegate)
        }
    }
    
    func enableLocation() -> Bool {
        return CLLocationManager.authorizationStatus() != .denied
    }
    
    func checkEnableLocation(_ presentingController: UIViewController) -> Bool {
        if !enableLocation() {
            
            if #available(iOS 8.0, *) {
                let controller = UIAlertController(title: "温馨提示", message: "定位被禁了，是否跳转到系统设置中修改？", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                controller.addAction(UIAlertAction(title: "去设置", style: .default, handler: { (action: UIAlertAction) in
                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                }))
                
                presentingController.present(controller, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
                
                UIAlertView(title: "温馨提示", message: "定位被禁了，请打开\n设置->隐私->定位服务->助家生活Ⅱ", delegate: nil, cancelButtonTitle: "确定").show()
            }
            
            return false
        }
        
        return true
    }
    
    //定位功能状态改变
    @objc internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            
        }
        NSLog("CLAuthorizationStatus: \(status.rawValue)")
    }
    
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied {
            
        }
        NSLog("CLAuthorizationStatus: \(manager.authorizationStatus.rawValue)")
    }
    
    @objc internal func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
    }
    
    @objc internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if 0 >= locations.count {
            for delegateItem in listDelegate {
                delegateItem.value?.locationManagerDidUpdateLocationGPS?(nil, placeMark: nil)
            }
            return
        }
        
        //获取当前城市街道等信息
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(locations[0]) { (listMark, error) in
            //有错误 返回
            if nil != error {
                NSLog("\(error?.localizedDescription ?? "")")
                for delegateItem in self.listDelegate {
                    delegateItem.value?.locationManagerDidUpdateLocationGPS?(locations[0], placeMark: nil)
                }
                return
            }
            
            //信息为空 返回
            if nil == listMark || 0 >= listMark!.count {
                for delegateItem in self.listDelegate {
                    delegateItem.value?.locationManagerDidUpdateLocationGPS?(locations[0], placeMark: nil)
                }
                return
            }
            
            let placeMark = listMark![0]
            
            //定位成功返回坐标点及Geo地址信息
            for delegateItem in self.listDelegate {
                delegateItem.value?.locationManagerDidUpdateLocationGPS?(locations[0], placeMark: placeMark)
            }
        }
    }
    
    @objc internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if !enableLocation() {
            _callbackCloseLocation?()
        }
        
        //定位失败协议
        for delegateItem in listDelegate {
            delegateItem.value?.locationManagerUpdateLocationError?(error as NSError?)
        }
    }
}
