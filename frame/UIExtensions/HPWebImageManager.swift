//
//  HPWebImageManager.swift
//  frame
//
//  Created by yl on 16/8/26.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit

class HPWebImageManager: NSObject {
    
    fileprivate var cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
    
    fileprivate static let _inst = HPWebImageManager()
    class var sharedInstance: HPWebImageManager {
        return _inst
    }
    
    func loadCacheWithUrlString(_ urlString: String?) {
        
        if nil != cachePath {
            let data = try? Data(contentsOf: URL(fileURLWithPath: (cachePath! as NSString).appendingPathComponent((urlString! as NSString).lastPathComponent)))
        }
    }
}
