//
//  HPToolLocation.swift
//  frame
//
//  Created by yl on 16/5/24.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit

class HPToolLocation: NSObject {
    class func distance(loc1: CLLocation?, loc2: CLLocation?) -> CLLocationDegrees {
        if nil == loc1 || nil == loc2 {
            return 0
        }
        
        return loc1!.distanceFromLocation(loc2!)
    }
    
    class func distance(pos1: CLLocationCoordinate2D?, pos2: CLLocationCoordinate2D?) -> CLLocationDegrees {
        if nil == pos1 || nil == pos2 {
            return 0
        }
        
        let loc1 = CLLocation(latitude: pos1!.latitude, longitude: pos1!.longitude)
        let loc2 = CLLocation(latitude: pos2!.latitude, longitude: pos2!.longitude)
        
        return loc1.distanceFromLocation(loc2)
    }
    
    class func distanceToString(distance: CLLocationDegrees?) -> String {
        if nil == distance {
            return "未知"
        }
        
        if distance >= 1000 {
            return String(format: "%.1fkm", distance!/1000)
        }else {
            return String(format: "%.0fm", distance!)
        }
    }
    
    class func convertFromGPSToBaidu(location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return BMKCoorDictionaryDecode(BMKConvertBaiduCoorFrom(location, BMK_COORDTYPE_GPS))//BMK_COORDTYPE_GPS GPS设备采集的原始GPS坐标
    }
}