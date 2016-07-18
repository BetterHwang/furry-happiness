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
    optional func locationManagerWillStartLocation(style: LocationStyle)
    optional func locationManagerDidStopLocation()
    optional func locationManagerDidUpdateLocationGPS(location: CLLocation?, placeMark: CLPlacemark?)
    optional func locationManagerUpdateLocationError(error: NSError?)
    optional func locationManagerDidEnterBackGround()
    optional func locationManagerWillEnterForeGround()
}

@objc enum LocationStyle: Int {
    case Always
    case InUsage
}

private typealias CallBackLocationManagerEnterBackground = (Void) -> Void
private typealias CallBackLocationManagerEnterForeground = (Void) -> Void

private let defaultLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)

class HPLocationManager: NSObject, CLLocationManagerDelegate {
    
    private var manageForSystem: CLLocationManager = CLLocationManager()
    
    static let sharedInstance = HPLocationManager()
    
    private var _callbackCloseLocation: ((Void) -> Void)?
    private var _currentLocation: CLLocationCoordinate2D = defaultLocation
    
    private var listDelegate = [HPLocationManagerDelegate]()
    
    private override init() {
        super.init()
        
        //定位用途 影响是否自动暂停定位
        manageForSystem.activityType = .AutomotiveNavigation
        //距离移动更新 最小值
        manageForSystem.distanceFilter = kCLDistanceFilterNone
        //精确度 最小值
        manageForSystem.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //转动角度更新 最小值
        manageForSystem.headingFilter = 1
        //设备方向
        manageForSystem.headingOrientation = .Portrait
        manageForSystem.delegate = self
        
        //app进入前后台事件
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HPLocationManager.appDidEnterBackground(_:)), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HPLocationManager.appWillEnterForeground(_:)), name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HPLocationManager.appWillTerminate(_:)), name: UIApplicationWillTerminateNotification, object: nil)
    }
    
    func appDidEnterBackground(notice: NSNotification) {
        //已经进入后台协议
        for delegateItem in listDelegate {
            delegateItem.locationManagerDidEnterBackGround?()
        }
    }
    
    func appWillEnterForeground(notice: NSNotification) {
        //进入前台前调用协议
        for delegateItem in listDelegate {
            delegateItem.locationManagerWillEnterForeGround?()
        }
    }
    
    func appWillTerminate(notice: NSNotification) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillTerminateNotification, object: nil)
    }
    
    func startLocation(style: LocationStyle, callbackCloseLocation: ((Void) -> Void)? = nil) {
        _callbackCloseLocation = callbackCloseLocation
        
        if !enableLocation() {
            UIAlertView(title: "温馨提示", message: "系统定位服务被关闭，请到设置中设置", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确定").show()
            return
        }
        
        switch style {
        case .Always:
            //永久使用
            if #available(iOS 8.0, *) {
                if (self.manageForSystem.respondsToSelector(#selector(CLLocationManager.requestAlwaysAuthorization))) {
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
                delegateItem.locationManagerWillStartLocation?(.Always)
            }
            break
        case .InUsage:
            //使用时开启
            if #available(iOS 8.0, *) {
                if (self.manageForSystem.respondsToSelector(#selector(CLLocationManager.requestWhenInUseAuthorization))) {
                    self.manageForSystem.requestWhenInUseAuthorization()
                }
            } else {
                // Fallback on earlier versions
            }
            
            //即将开启定位协议
            for delegateItem in listDelegate {
                delegateItem.locationManagerWillStartLocation?(.InUsage)
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
            delegateItem.locationManagerDidStopLocation?()
        }
    }
    
    func addDelegate(delegate: HPLocationManagerDelegate) {
        var markHasDelegate: Bool = false
        for delegateItem in listDelegate {
            if delegateItem === delegate {
                markHasDelegate = true
                break
            }
        }
        
        //若未有 则添加
        if !markHasDelegate {
            listDelegate.append(delegate)
        }
    }
    
    func removeDelegate(delegate: HPLocationManagerDelegate) {
        var markHasDelegate: Bool = false
        var index: Int = 0
        for delegateItem in listDelegate {
            if delegateItem === delegate {
                markHasDelegate = true
                break
            }
            
            index += 1
        }
        
        //若已有 则删除
        if markHasDelegate {
            listDelegate.removeAtIndex(index)
        }
    }
    
    func enableLocation() -> Bool {
        return CLLocationManager.authorizationStatus() != .Denied
    }
    
    func checkEnableLocation(presentingController: UIViewController) -> Bool {
        if !enableLocation() {
            
            if #available(iOS 8.0, *) {
                let controller = UIAlertController(title: "温馨提示", message: "定位被禁了，是否跳转到系统设置中修改？", preferredStyle: .Alert)
                controller.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
                controller.addAction(UIAlertAction(title: "去设置", style: .Default, handler: { (action: UIAlertAction) in
                    UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
                }))
                
                presentingController.presentViewController(controller, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
                
                UIAlertView(title: "温馨提示", message: "定位被禁了，请打开\n设置->隐私->定位服务->助家生活Ⅱ", delegate: nil, cancelButtonTitle: "确定").show()
            }
            
            return false
        }
        
        return true
    }
    
    func convertFromGPSToBaidu(location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return BMKCoorDictionaryDecode(BMKConvertBaiduCoorFrom(location, BMK_COORDTYPE_GPS))
    }
    
    //定位功能状态改变
    @objc internal  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        NSLog("CLAuthorizationStatus: \(status.rawValue)")
    }
    
    @objc internal func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
    }
    
    @objc internal func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if 0 >= locations.count {
            for delegateItem in listDelegate {
                delegateItem.locationManagerDidUpdateLocationGPS?(nil, placeMark: nil)
            }
            return
        }
        
        //获取当前城市街道等信息
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(locations[0]) { (listMark: [CLPlacemark]?, error: NSError?) in
            //有错误 返回
            if nil != error {
                NSLog("\(error?.localizedDescription)")
                for delegateItem in self.listDelegate {
                    delegateItem.locationManagerDidUpdateLocationGPS?(locations[0], placeMark: nil)
                }
                return
            }
            
            //信息为空 返回
            if nil == listMark || 0 >= listMark?.count {
                for delegateItem in self.listDelegate {
                    delegateItem.locationManagerDidUpdateLocationGPS?(locations[0], placeMark: nil)
                }
                return
            }
            
            let placeMark = listMark![0]
            
            //定位成功返回坐标点及Geo地址信息
            for delegateItem in self.listDelegate {
                delegateItem.locationManagerDidUpdateLocationGPS?(locations[0], placeMark: placeMark)
            }
        }
    }
    
    @objc internal func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if !enableLocation() {
            _callbackCloseLocation?()
        }
        
        //定位失败协议
        for delegateItem in listDelegate {
            delegateItem.locationManagerUpdateLocationError?(error)
        }
    }
}
