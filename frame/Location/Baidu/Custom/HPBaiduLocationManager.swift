//
//  HPBaiduLocationManager.swift
//  frame
//
//  Created by yl on 16/4/26.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit
@objc protocol HPBaiduLocationManagerDelegate: NSObjectProtocol {
    @objc optional func locationManagerWillStartLocation(_ style: LocationStyle)
    @objc optional func locationManagerDidStopLocation()
    @objc optional func locationManagerDidUpdateLocationGPS(_ location: CLLocation?, placeMark: CLPlacemark?)
    @objc optional func locationManagerUpdateLocationError(_ error: NSError?)
}

private let defaultLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)

class HPBaiduLocationManager: NSObject, BMKLocationServiceDelegate {
    
    fileprivate let locService = BMKLocationService()
    
    fileprivate static let _inst = HPBaiduLocationManager()
    class var sharedInstance: HPBaiduLocationManager {
        return _inst
    }
    
    fileprivate var _callbackCloseLocation: ((Void) -> Void)?
    fileprivate var _currentLocation: CLLocationCoordinate2D = defaultLocation
    
    var delegate: HPBaiduLocationManagerDelegate?
    
    fileprivate override init() {
        super.init()
        
        //距离移动更新 最小值
        locService.distanceFilter = kCLDistanceFilterNone
        //精确度 最小值
        locService.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //转动角度更新 最小值
        locService.headingFilter = 1
        locService.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(HPBaiduLocationManager.appWillResignActive(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HPBaiduLocationManager.appWillTerminate(_:)), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
    }
    
    func appWillResignActive(_ notice: Notification) {
        
    }
    
    func appWillTerminate(_ notice: Notification) {
        
    }
    
    //启动始终或者使用时开启 由plist中NSLocationAlwaysUsageDescription或NSLocationWhenInUseUsageDescription 决定
    func startLocation(_ style: LocationStyle, callbackCloseLocation: ((Void) -> Void)? = nil) {
        _callbackCloseLocation = callbackCloseLocation
        
        if !enableLocation() {
            UIAlertView(title: "温馨提示", message: "系统定位服务被关闭，请到设置中设置", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确定").show()
            return
        }
        
        switch style {
        case .always:
            //永久使用
            //background保持定位
            locService.allowsBackgroundLocationUpdates = true
            
            //pausesLocationUpdatesAutomatically为false && capabilities->Background Modes->Location Updates 勾选
            //动态暂停关闭
            locService.pausesLocationUpdatesAutomatically = false
            break
        case .inUsage:
            //使用时开启
            //选用默认参数可不做处理
            break
        }
        
        locService.startUserLocationService()
    }
    
    func stopLocation() {
        locService.stopUserLocationService()
    }
    
    func enableLocation() -> Bool {
        return CLLocationManager.authorizationStatus() != .denied
    }
    
    //delegate
    @objc internal func willStartLocatingUser() {
        
    }
    
    @objc internal func didStopLocatingUser() {
        
    }
    
    @objc internal func didUpdateUserHeading(_ userLocation: BMKUserLocation!) {
        
    }
    
    @objc internal func didUpdate(_ userLocation: BMKUserLocation!) {
        NSLog("\(userLocation.location)")
    }
    
    @objc internal func didFailToLocateUserWithError(_ error: NSError!) {
        if !enableLocation() {
            _callbackCloseLocation?()
        }
        NSLog("\(error.localizedDescription)")
    }
}
