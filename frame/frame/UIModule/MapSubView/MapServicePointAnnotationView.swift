//
//  MapServicePointAnnotationView.swift
//  frame
//
//  Created by yl on 16/8/25.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit

class MapServicePointAnnotationView: BMKAnnotationView {
    var annotationServicePoint: MapServicePointAnnotation?
    
    fileprivate var labelBadge: UILabel?
    fileprivate var imageViewServicePoint: UIImageView = UIImageView()
    
    fileprivate var placeImage = UIImage(named: "")

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//    }
//    
    init(annotation: MapServicePointAnnotation, identifier: String) {
        super.init(annotation: annotation, reuseIdentifier: identifier)
        
        self.annotationServicePoint = annotation
        customInit()
    }
    
    override func removeFromSuperview() {
        let rect = self.frame
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect(x: rect.midX, y: rect.maxY, width: 1, height: 1)
            self.alpha = 0
            }, completion: { finished in
            
        })
    }
    
    func selectServicePoint(_ selected: Bool) {
        //处理annotation选中及取消选中
    }
    
    //number为个位数
    func showBadge(_ number: Int) {
        if nil == self.labelBadge {
            let label = UILabel(frame: CGRect(x: -10, y: -10, width: 20, height: 20))
            label.font = UIFont.systemFont(ofSize: 14)
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.backgroundColor = UIColor.blue
            label.layer.cornerRadius = 3.0
            label.layer.masksToBounds = true
            
            self.labelBadge = label
        }
        
        labelBadge?.text = "\(number)"
        self.addSubview(self.labelBadge!)
    }
    
    func removeBadge() {
        labelBadge?.removeFromSuperview()
    }
    
    func customInit() {
        //选中时不弹出气泡
        self.canShowCallout = false
        
        imageViewServicePoint.image = placeImage
        
        self.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        self.alpha = 0
        self.backgroundColor = UIColor.white
        UIView.animate(withDuration: 0.3, animations: { 
            self.frame = CGRect(x: -25, y: -50, width: 50, height: 50)
            self.alpha = 1
            }, completion: { finished in
                
        })
    }
}
