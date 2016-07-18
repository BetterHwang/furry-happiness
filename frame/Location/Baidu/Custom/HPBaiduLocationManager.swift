//
//  HPBaiduLocationManager.swift
//  frame
//
//  Created by yl on 16/4/26.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit
@objc protocol HPBaiduLocationManagerDelegate: NSObjectProtocol {
    optional func locationManagerWillStartLocation(style: LocationStyle)
    optional func locationManagerDidStopLocation()
    optional func locationManagerDidUpdateLocationGPS(location: CLLocation?, placeMark: CLPlacemark?)
    optional func locationManagerUpdateLocationError(error: NSError?)
}

private let defaultLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)

class HPBaiduLocationManager: NSObject, BMKLocationServiceDelegate {
    
    private let locService = BMKLocationService()
    
    private static let _inst = HPBaiduLocationManager()
    class var sharedInstance: HPBaiduLocationManager {
        return _inst
    }
    
    private var _callbackCloseLocation: ((Void) -> Void)?
    private var _currentLocation: CLLocationCoordinate2D = defaultLocation
    
    var delegate: HPBaiduLocationManagerDelegate?
    
    private override init() {
        super.init()
        
        //距离移动更新 最小值
        locService.distanceFilter = kCLDistanceFilterNone
        //精确度 最小值
        locService.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //转动角度更新 最小值
        locService.headingFilter = 1
        locService.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HPBaiduLocationManager.appWillResignActive(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HPBaiduLocationManager.appWillTerminate(_:)), name: UIApplicationWillTerminateNotification, object: nil)
    }
    
    func appWillResignActive(notice: NSNotification) {
        
    }
    
    func appWillTerminate(notice: NSNotification) {
        
    }
    
    //启动始终或者使用时开启 由plist中NSLocationAlwaysUsageDescription或NSLocationWhenInUseUsageDescription 决定
    func startLocation(style: LocationStyle, callbackCloseLocation: ((Void) -> Void)? = nil) {
        _callbackCloseLocation = callbackCloseLocation
        
        if !enableLocation() {
            UIAlertView(title: "温馨提示", message: "系统定位服务被关闭，请到设置中设置", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确定").show()
            return
        }
        
        switch style {
        case .Always:
            //永久使用
            //background保持定位
            locService.allowsBackgroundLocationUpdates = true
            
            //pausesLocationUpdatesAutomatically为false && capabilities->Background Modes->Location Updates 勾选
            //动态暂停关闭
            locService.pausesLocationUpdatesAutomatically = false
            break
        case .InUsage:
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
        return CLLocationManager.authorizationStatus() != .Denied
    }
    
    //delegate
    @objc internal func willStartLocatingUser() {
        
    }
    
    @objc internal func didStopLocatingUser() {
        
    }
    
    @objc internal func didUpdateUserHeading(userLocation: BMKUserLocation!) {
        
    }
    
    @objc internal func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        NSLog("\(userLocation.location)")
    }
    
    @objc internal func didFailToLocateUserWithError(error: NSError!) {
        if !enableLocation() {
            _callbackCloseLocation?()
        }
        NSLog("\(error.localizedDescription)")
    }
}
