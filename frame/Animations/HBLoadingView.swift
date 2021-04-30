//
//  HBLoadingView.swift
//  frame
//
//  Created by apple on 2021/4/30.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation

protocol HBLoadingViewProtocol: NSObjectProtocol {
//    typealias BlockFinished = (_ finished: Bool) -> Void
    func animateIn()
    func animateOut()
}

class HBLoadingView: UIView, CAAnimationDelegate, HBLoadingViewProtocol {
    private var animationIn: CAAnimation!
    private var animationOut: CAAnimation!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        alpha = 1.0
        
        animationIn = getAnimationIn()
        animationOut = getAnimationOut()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func animateIn() {
        layer.add(animationIn, forKey: "animationIn")
        
        perform(#selector(animateOut), with: self, afterDelay: 2.0)
    }
    
    @objc func animateOut() {
        layer.add(animationOut, forKey: "animationOut")
        
    }
    
    private func getAnimationIn() -> CAAnimation {
        CATransaction.begin()
        let animation = CAKeyframeAnimation.init(keyPath: "opacity")
        animation.values = [0, 1.0]
        animation.duration = 0.3
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction.init(name: .easeIn)
        CATransaction.commit()
        
        return animation
    }
    
    private func getAnimationOut() -> CAAnimation {
        CATransaction.begin()
        let animation = CAKeyframeAnimation.init(keyPath: "opacity")
        animation.values = [1.0, 0.0]
        animation.duration = 0.2
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction.init(name: .easeOut)
        CATransaction.commit()
        
        return animation
    }
    
    deinit {
        layer.removeAllAnimations()
    }
    
    // MARK: - CAAnimationDelegate
    func animationDidStart(_ anim: CAAnimation) {
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if !flag {
            return
        }
        
        if anim == layer.animation(forKey: "animationOut") {
            alpha = 0.0
            layer.removeAnimation(forKey: "animationOut")
            removeFromSuperview()
        }else if anim == layer.animation(forKey: "animationIn") {
//            alpha = 1.0
            layer.removeAnimation(forKey: "animationIn")
        }
    }
    
    // MARK: - Class funcs
    class func show(to view: UIView? = nil) {
        let viewLoading = HBLoadingView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        
        if nil != view {
            view?.addSubview(viewLoading)
        }else {
            let keyWindow = UIApplication.shared.windows.first{$0.isKeyWindow}
            keyWindow?.addSubview(viewLoading)
        }
        
        viewLoading.animateIn()
    }
}
