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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


@objc protocol HPLocationManagerDelegate: NSObjectProtocol {
    @objc optional func locationManagerWillStartLocation(_ style: LocationStyle)
    @objc optional func locationManagerDidStopLocation()
    @objc optional func locationManagerDidUpdateLocationGPS(_ location: CLLocation?, placeMark: CLPlacemark?)
    @objc optional func locationManagerUpdateLocationError(_ error: NSError?)
    @objc optional func locationManagerDidEnterBackGround()
    @objc optional func locationManagerWillEnterForeGround()
}

@objc enum LocationStyle: Int {
    case always
    case inUsage
}

private typealias CallBackLocationManagerEnterBackground = (Void) -> Void
private typealias CallBackLocationManagerEnterForeground = (Void) -> Void

private let defaultLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)

class HPLocationManager: NSObject, CLLocationManagerDelegate {
    
    fileprivate var manageForSystem: CLLocationManager = CLLocationManager()
    
    static let sharedInstance = HPLocationManager()
    
    fileprivate var _callbackCloseLocation: ((Void) -> Void)?
    fileprivate var _currentLocation: CLLocationCoordinate2D = defaultLocation
    
    fileprivate var listDelegate = [HPLocationManagerDelegate]()
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(HPLocationManager.appDidEnterBackground(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HPLocationManager.appWillEnterForeground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HPLocationManager.appWillTerminate(_:)), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
    }
    
    func appDidEnterBackground(_ notice: Notification) {
        //已经进入后台协议
        for delegateItem in listDelegate {
            delegateItem.locationManagerDidEnterBackGround?()
        }
    }
    
    func appWillEnterForeground(_ notice: Notification) {
        //进入前台前调用协议
        for delegateItem in listDelegate {
            delegateItem.locationManagerWillEnterForeGround?()
        }
    }
    
    func appWillTerminate(_ notice: Notification) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
    }
    
    func startLocation(_ style: LocationStyle, callbackCloseLocation: ((Void) -> Void)? = nil) {
        _callbackCloseLocation = callbackCloseLocation
        
        if !enableLocation() {
            UIAlertView(title: "温馨提示", message: "系统定位服务被关闭，请到设置中设置", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确定").show()
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
                delegateItem.locationManagerWillStartLocation?(.always)
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
                delegateItem.locationManagerWillStartLocation?(.inUsage)
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
    
    func addDelegate(_ delegate: HPLocationManagerDelegate) {
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
    
    func removeDelegate(_ delegate: HPLocationManagerDelegate) {
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
            listDelegate.remove(at: index)
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
                    UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
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
    
    func convertFromGPSToBaidu(_ location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return BMKCoorDictionaryDecode(BMKConvertBaiduCoorFrom(location, BMK_COORDTYPE_GPS))
    }
    
    //定位功能状态改变
    @objc internal  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        NSLog("CLAuthorizationStatus: \(status.rawValue)")
    }
    
    @objc internal func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
    }
    
    @objc internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if 0 >= locations.count {
            for delegateItem in listDelegate {
                delegateItem.locationManagerDidUpdateLocationGPS?(nil, placeMark: nil)
            }
            return
        }
        
        //获取当前城市街道等信息
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(locations[0]) { (listMark, error) in
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
    
    @objc internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if !enableLocation() {
            _callbackCloseLocation?()
        }
        
        //定位失败协议
        for delegateItem in listDelegate {
            delegateItem.locationManagerUpdateLocationError?(error as NSError?)
        }
    }
}
