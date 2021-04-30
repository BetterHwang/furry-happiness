//
//  MapCenterAnnotationView.swift
//  frame
//
//  Created by yl on 16/8/24.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit

class MapCenterAnnotationView: UIView {
    static let Min_TextWidth: CGFloat = 60
    static let Max_TextWidth: CGFloat = 200
    static let Padding: CGFloat = 10
    static let ViewHeight: CGFloat = 40
    
    fileprivate var imageBackground = UIImage(named: "Background")
    fileprivate var imageArrow = UIImage(named: "Arrow_ViewDirection")
    
    var indicator: HorizontalThreeGradientIndicator?
    var labelAddress: UILabel = UILabel()
    var imageViewArrow: UIImageView = UIImageView()
    var imageViewBackground: UIImageView = UIImageView()
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customInit(frame)
    }
    
    override func removeFromSuperview() {
        self.labelAddress.text = ""
        UIView.animate(withDuration: 0.3, animations: {
            self.refreshView(MapCenterAnnotationView.Min_TextWidth)
            self.alpha = 0
            }, completion: { finshed in
                super.removeFromSuperview()
        })
    }
    
    func customInit(_ frame: CGRect) {
        imageViewBackground.frame = self.bounds
        imageViewBackground.image = imageBackground?.stretchableImage(withLeftCapWidth: 30, topCapHeight: 30)
        self.addSubview(imageViewBackground)
        
        indicator = HorizontalThreeGradientIndicator(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        indicator?.startAnimating(true)
        self.addSubview(indicator!)
        
        labelAddress.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        labelAddress.font = UIFont.systemFont(ofSize: 16)
        labelAddress.textAlignment = .center
        
        if let image = imageArrow {
            imageViewArrow.image = image
            imageViewArrow.frame = CGRect(x: self.bounds.width/2 - image.size.width/2, y: self.bounds.height - 1, width: image.size.width, height: image.size.height)
            self.addSubview(imageViewArrow)
        }
        
        self.clipsToBounds = false
        self.backgroundColor = UIColor.clear
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.green.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.8
    }
    
    func showAddress(_ address: String?) {
        indicator?.stopAnimating(true)
        
        UIView.animate(withDuration: 0.3, animations: {
            let viewWidth = MapCenterAnnotationView.getViewWidth(address)
            self.refreshView(viewWidth)
            
            }, completion: { finished in
                self.labelAddress.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                self.labelAddress.text = address
                self.addSubview(self.labelAddress)
        })
    }
    
    func refreshView(_ width: CGFloat) {
        self.frame = CGRect(x: self.center.x - width/2, y: self.center.y - MapCenterAnnotationView.ViewHeight/2, width: width, height: MapCenterAnnotationView.ViewHeight)
        self.imageViewArrow.frame = CGRect(x: self.bounds.width/2 - self.imageViewArrow.frame.width/2, y: self.bounds.height - 1, width: self.imageViewArrow.frame.width, height: self.imageViewArrow.frame.height)
        self.imageViewBackground.frame = self.bounds
        self.imageViewBackground.image = imageBackground?.stretchableImage(withLeftCapWidth: 30, topCapHeight: 30)
    }
    
    class func showAnnotationViewAbove(_ superView: UIView, position: CGPoint) -> MapCenterAnnotationView {
        let annotationView = MapCenterAnnotationView(frame: CGRect(x: position.x - Min_TextWidth/2, y: position.y - ViewHeight, width: Min_TextWidth, height: ViewHeight))
        annotationView.alpha = 0
        superView.addSubview(annotationView)
        
        UIView.animate(withDuration: 0.3, animations: {
            annotationView.alpha = 1
        }) 
        return annotationView
    }
    
    fileprivate class func getViewWidth(_ address: String?) -> CGFloat {
        if nil == address {
            return Min_TextWidth
        }
        
        let textWidth = address!.getWidth(limitedHeight: 20, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
        
        return (textWidth < Min_TextWidth ? Min_TextWidth : (textWidth > Max_TextWidth ? Max_TextWidth : textWidth)) + 2*Padding
    }
}
