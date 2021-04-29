//
//  HorizontalThreeGradientIndicator.swift
//  frame
//
//  Created by yl on 16/8/24.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit

protocol IndicatorProtocol: NSObjectProtocol {
    func startAnimating(_ animated: Bool)
    func stopAnimating(_ animated: Bool)
    func addAnimation()
    func removeAnimation()
}

private var HorizontalThreeGradientIndicatorSizeAnimation = "HorizontalThreeGradientIndicatorSizeAnimation"
private var HorizontalThreeGradientIndicatorColorAnimation = "HorizontalThreeGradientIndicatorColorAnimation"
class HorizontalThreeGradientIndicator: UIView, IndicatorProtocol, CAAnimationDelegate {
    let Material_Width: CGFloat = 10
    let Material_Color: UIColor = UIColor.gray
    
    //三个材质
    var subLayer1: CAShapeLayer?
    var subLayer2: CAShapeLayer?
    var subLayer3: CAShapeLayer?
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupAnimationLayer()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAnimationLayer()
    }
    
    func setupAnimationLayer() {
        let subLayer1 = CAShapeLayer(layer: self.layer)
        subLayer1.bounds = CGRect(x: self.bounds.width/4 - Material_Width/2, y: self.bounds.height/2 - Material_Width/2, width: Material_Width, height: Material_Width)//self.layer.bounds
        subLayer1.position = CGPoint(x: self.bounds.width/4, y: self.bounds.height/2)//CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        subLayer1.fillColor = Material_Color.cgColor
        subLayer1.path = self.layoutPath(subLayer1.position).cgPath//self.layoutPath(CGPointMake(self.bounds.width/4, self.bounds.height/2)).CGPath
        self.subLayer1 = subLayer1
        
        let subLayer2 = CAShapeLayer(layer: self.layer)
        subLayer2.bounds = CGRect(x: self.bounds.width/2 - Material_Width/2, y: self.bounds.height/2 - Material_Width/2, width: Material_Width, height: Material_Width)//self.layer.bounds
        subLayer2.position = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)//CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        subLayer2.fillColor = Material_Color.cgColor
        subLayer2.path = self.layoutPath(subLayer2.position).cgPath//self.layoutPath(CGPointMake(self.bounds.width/2, self.bounds.height/2)).CGPath
        self.subLayer2 = subLayer2
        
        let subLayer3 = CAShapeLayer(layer: self.layer)
        subLayer3.bounds = CGRect(x: self.bounds.width*3/4 - Material_Width/2, y: self.bounds.height/2 - Material_Width/2, width: Material_Width, height: Material_Width)//self.layer.bounds
        subLayer3.position = CGPoint(x: self.bounds.width*3/4, y: self.bounds.height/2)//CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        subLayer3.fillColor = Material_Color.cgColor
        subLayer3.path = self.layoutPath(subLayer3.position).cgPath//self.layoutPath(CGPointMake(self.bounds.width*3/4, self.bounds.height/2)).CGPath
        self.subLayer3 = subLayer3
        
        self.layer.addSublayer(subLayer1)
        self.layer.addSublayer(subLayer2)
        self.layer.addSublayer(subLayer3)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func layoutPath(_ postion: CGPoint) -> UIBezierPath {
        let TWO_M_PI: CGFloat = CGFloat(2.0 * Double.pi)
        
        return UIBezierPath(arcCenter: postion, radius: Material_Width/2, startAngle: 0, endAngle: TWO_M_PI, clockwise: true)
    }
    
    func startAnimating(_ animated: Bool) {
        stopAnimating(false)
        
        //渐现
        if animated {
            
            self.alpha = 0
            self.addAnimation()
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 1
            }, completion: { (finished) in
            }) 
        }else {
            self.addAnimation()
        }
    }
    
    func stopAnimating(_ animated: Bool) {
        if animated {
            //渐隐
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 0
            }, completion: { (finished) in
                self.removeAnimation()
            }) 
        }else {
            self.removeAnimation()
        }
    }
    
    internal func addAnimation() {
        let animationSize1 = CAKeyframeAnimation(keyPath: "transform.scale")
        animationSize1.duration = 2
        animationSize1.repeatCount = MAXFLOAT
        animationSize1.delegate = self
        animationSize1.values = [0.5, 1, 0.5]
        
        let animationSize2 = CAKeyframeAnimation(keyPath: "transform.scale")
        animationSize2.duration = 2
        animationSize2.repeatCount = MAXFLOAT
        animationSize2.delegate = self
        animationSize2.values = [1, 0.5, 1]
        
        self.subLayer1?.add(animationSize1, forKey: HorizontalThreeGradientIndicatorSizeAnimation)
        self.subLayer2?.add(animationSize2, forKey: HorizontalThreeGradientIndicatorSizeAnimation)
        self.subLayer3?.add(animationSize1, forKey: HorizontalThreeGradientIndicatorSizeAnimation)
    }
    
    internal func removeAnimation() {
        self.subLayer1?.removeAnimation(forKey: HorizontalThreeGradientIndicatorSizeAnimation)
        self.subLayer2?.removeAnimation(forKey: HorizontalThreeGradientIndicatorSizeAnimation)
        self.subLayer3?.removeAnimation(forKey: HorizontalThreeGradientIndicatorSizeAnimation)
    }
}
