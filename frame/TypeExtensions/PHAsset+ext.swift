//
//  PHAsset+ext.swift
//  frame
//
//  Created by apple on 2021/5/21.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation
import Photos

extension PHAsset {
    func videoTrans(outputPath: String, outputFileType: AVFileType = .mp4, presetName: String = AVAssetExportPresetHighestQuality) {
        if mediaType != .video || outputPath.isEmpty {
            return
        }
        
        let options = PHVideoRequestOptions.init()
        options.version = .original
        PHImageManager.default().requestAVAsset(forVideo: self, options: options) { (avAsset: AVAsset?, avAudioMix: AVAudioMix?, info: [AnyHashable : Any]?) in
            guard let urlAsset = avAsset as? AVURLAsset else {
//                callback(false, "获取数据出错", "")
                return
            }
            
            do {
                let values =  try urlAsset.url.resourceValues(forKeys: [.fileSizeKey, .nameKey, .pathKey, .fileResourceTypeKey])
                guard let _ = values.allValues.first(where: {$0.key == URLResourceKey.nameKey})?.value as? String else {
//                    callback(false, "获取数据出错")
                    return
                }
                
                guard let exportSession = AVAssetExportSession.init(asset: urlAsset, presetName: presetName) else {
                    return
                }
                
                let path = outputPath
                exportSession.outputURL = URL.init(fileURLWithPath: path)
                exportSession.outputFileType = outputFileType
                exportSession.shouldOptimizeForNetworkUse = true
                exportSession.exportAsynchronously {
                    DispatchQueue.main.async {
                        if !FileManager.default.fileExists(atPath: path) {
//                            callback(false, "转换过程出错", "")
                            return
                        }
                        
                        
//                        do {
//                            let dict = try FileManager.default.attributesOfItem(atPath: path)
//                            callback(true, "succeed", path)
//                        }catch _ {
//                            callback(true, "获取数据出错", "")
//                        }
                    }
                
                }
                
            } catch _ {
//                callback(true, "获取数据出错")
            }
        }
    }
    
    func getFileInfo(callback: @escaping ((_ info: URLResourceValues?, _ error: NSError?)-> Void)) {
        switch mediaType {
        case .image:
            break
        case .video:
            let options = PHVideoRequestOptions.init()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options) { (avAsset: AVAsset?, avAudioMix: AVAudioMix?, info: [AnyHashable : Any]?) in
                guard let urlAsset = avAsset as? AVURLAsset else {
                    let error = NSError.init(domain: "", code: 0, userInfo: ["reason" : "获取数据出错"])
                    callback(nil, error)
                    return
                }
                
                do {
                    let reasourceValue =  try urlAsset.url.resourceValues(forKeys: [.fileSizeKey, .nameKey, .pathKey, .fileResourceTypeKey])
                    callback(reasourceValue, nil)
                } catch _ {
                    let error = NSError.init(domain: "", code: 0, userInfo: ["reason" : "获取数据出错"])
                    callback(nil, error)
                }
            }
            break
        case .audio:
            break
        default:
            break
        }
    }
    
    func checkImage(_ size: Int64, _ callback:@escaping ((_ result: Bool, _ reason: String, _ imageData: Data?) -> Void)) {
        if mediaType != .image {
            callback(false, "不是图片", nil)
            return
        }
        
        if #available(iOS 13, *) {
            PHImageManager.default().requestImageDataAndOrientation(for: self, options: nil) { (data, string, orientation, info: [AnyHashable : Any]?) in
                guard let sizeImage = data?.count else {
                    callback(false, "获取图片大小失败", nil)
                    return
                }
                
                if sizeImage > size {
                    callback(false, "超过大小限制", nil)
                    return
                }
                
                callback(true, "", data)
            }
        } else {
            // Fallback on earlier versions
            PHImageManager.default().requestImageData(for: self, options: nil) { data, string, orientation, info in
                guard let sizeImage = data?.count else {
                    callback(false, "获取图片大小失败", nil)
                    return
                }
                
                if sizeImage > size {
                    callback(false, "超过大小限制", nil)
                    return
                }
                
                callback(true, "", data)
            }
        }
    }
    
    func checkVideo(_ size: Int64, _ definition: Int, _ length: Int, _ callback:@escaping ((_ result: Bool, _ reason: String, _ resPath: String) -> Void)) {
        if mediaType != .video {
            callback(false, "不是视频", "")
            return
        }
        
        if Int(duration) > length {
            callback(false, "超过限制时长", "")
            return
        }
        
//        if pixelHeight > definition {
//            callback(false, "超过限制清晰度")
//            return
//        }
        
//        let videpLength = duration
        let options = PHVideoRequestOptions.init()
        options.version = .original
        PHImageManager.default().requestAVAsset(forVideo: self, options: options) { (avAsset: AVAsset?, avAudioMix: AVAudioMix?, info: [AnyHashable : Any]?) in
            guard let urlAsset = avAsset as? AVURLAsset else {
                callback(false, "获取数据出错", "")
                return
            }
            
            guard let exportSession = AVAssetExportSession.init(asset: urlAsset, presetName: AVAssetExportPreset1280x720) else {
                callback(false, "创建转换格式出错", "")
                return
            }
            
            let path = FileManager.mp4CachePath(fileName: "temp_video.mp4")
            exportSession.outputURL = URL.init(fileURLWithPath: path)
            exportSession.outputFileType = .mp4
            exportSession.shouldOptimizeForNetworkUse = true
            
            exportSession.exportAsynchronously {
                DispatchQueue.main.async {
                    if !FileManager.default.fileExists(atPath: path) {
                        callback(false, "转换过程出错", "")
                        return
                    }
                    
                    do {
                        let dict = try FileManager.default.attributesOfItem(atPath: path)
                        guard let fileSize = dict[FileAttributeKey.size] as? NSNumber else {
                            callback(false, "获取存储大小失败", "")
                            return
                        }
                        
                        if fileSize.int64Value > size {
                            callback(false, "超过存储大小限制", "")
                            return
                        }
                        
                        callback(true, "succeed", path)
                    }catch _ {
                        callback(true, "获取数据出错", "")
                    }
                }
            }
//
//            do {
//                let values =  try urlAsset.url.resourceValues(forKeys: [.fileSizeKey])
//                guard let sizeVideo = values.allValues.first(where: {$0.key == URLResourceKey.fileSizeKey})?.value as? NSNumber else {
//                    callback(false, "获取数据出错")
//                    return
//                }
//
//                if sizeVideo.int64Value > size {
//                    callback(false, "超过存储大小限制")
//                    return
//                }
//
//                callback(true, "succeed")
//            } catch _ {
//                callback(true, "获取数据出错")
//            }
        }
    }
}

extension FileManager {
    class func mp4CachePath(fileName: String) -> String {
        let tempDir = NSTemporaryDirectory().appending("Cache/Video/")
        
        var isDir = ObjCBool.init(booleanLiteral: false)
        let isExistDir = FileManager.default.fileExists(atPath: tempDir, isDirectory: &isDir)
        if (!(isExistDir && isDir.boolValue)) {
            do {
                let url = URL.init(fileURLWithPath: tempDir, isDirectory: true)
                
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                
                return tempDir + fileName
                
            } catch _ {
                return ""
            }
        }
        
        return tempDir + fileName
    }
}
