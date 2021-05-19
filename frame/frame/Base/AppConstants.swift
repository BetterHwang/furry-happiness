//
//  AppConstants.swift
//  frame
//
//  Created by apple on 2021/4/29.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

let SCALEW : CGFloat = SCREEN_WIDTH/375.0
let SCALEH : CGFloat = SCREEN_HEIGHT/812.0

var isFullScreen: Bool {
    if #available(iOS 11, *) {
        guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
            return false
        }
        
        if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
            print(unwrapedWindow.safeAreaInsets)
            return true
        }
    }
    return false
}

func getIsIpad() -> Bool{
    let deviceType = UIDevice.current.model;
    if deviceType == "iPad" {
        return true;
    }
    return false;
}

let isPhoneX = isFullScreen

//适配iPhoneX
//获取状态栏的高度，全面屏手机的状态栏高度为44pt，非全面屏手机的状态栏高度为20pt

//状态栏高度
let statusBarHeight = isPhoneX ? CGFloat(44.0) : CGFloat(20.0)

//导航栏高度
let navigationHeight = (UIApplication.shared.statusBarFrame.height + 44)

//tabbar高度
let tabBarHeight : CGFloat = (UIApplication.shared.statusBarFrame.height == 44 ? 83.0 : 49.0)

//顶部的安全距离
let topSafeAreaHeight = (UIApplication.shared.statusBarFrame.height - 20)

//底部的安全距离
let bottomSafeAreaHeight = (UIApplication.shared.statusBarFrame.height - 49)

//底部的安全距离
let safeBottom = isPhoneX ? CGFloat(34.0):0.0

//底部的安全距离
let safeSapceBottom = isPhoneX ? CGFloat(15.0):0.0
//底部栏高度
let bottomForHeight = isPhoneX ? CGFloat(65) : CGFloat(50)

class AppConstants {
    
}
