//
//  HPGravityModalTransition.swift
//  frame
//
//  Created by yl on 16/12/2.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit
enum HPModalTransitionType {
    case present
    case dismiss
}

class HPGravityModalTransition: NSObject, UIViewControllerAnimatedTransitioning, UIDynamicAnimatorDelegate {

    fileprivate var duration: TimeInterval = 0.3
    fileprivate var type: HPModalTransitionType = .present
    
    fileprivate var lastTransitionContext: UIViewControllerContextTransitioning?
    
    class func transitionWithType(_ type: HPModalTransitionType, duration: TimeInterval) -> HPGravityModalTransition {
        let transition = HPGravityModalTransition()
        transition.duration = duration
        transition.type = type
        
        return transition
    }
    
    //UIDynamicAnimatorDelegate
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        
    }
    
    func dynamicAnimatorWillResume(_ animator: UIDynamicAnimator) {
        
    }
    
    //UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch self.type {
        case .present:
            self.Present(transitionContext)
            break
        case .dismiss:
            self.dismiss(transitionContext)
            break
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        
    }
    
    //Private Method 
    func Present(_ transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        if nil == fromVC || nil == toVC || nil == containerView {
            return
        }
        
        let containerViewFrame = containerView.frame
//        containerView?.addSubview(fromVC!.view)
        containerView.addSubview(toVC!.view)
        
        let screenSize = UIScreen.main.bounds.size
        toVC!.view.frame = CGRect(x: 0, y: containerViewFrame.height, width: containerViewFrame.width, height: screenSize.height)
//        
//        let behaviorGravity = UIGravityBehavior()
//        //添加重力作用物质
//        behaviorGravity.addItem(toVC!.view)
//        //重力方向
//        behaviorGravity.gravityDirection = CGVectorMake(0, 1)
////        //弧度 影响重力方向
////        behaviorGravity.angle = CGFloat(30*M_PI/180)
//        //速度
//        behaviorGravity.magnitude = 10
//        
//        let behaviorCollision = UICollisionBehavior()
//        behaviorCollision.addItem(toVC!.view)
//        //设置碰撞模式
//        behaviorCollision.collisionMode = .Everything
//        //以参照视图为边界范围
//        behaviorCollision.translatesReferenceBoundsIntoBoundary = false
//        behaviorCollision.addBoundaryWithIdentifier("XXXXXX", fromPoint: CGPointMake(0, screenSize.height), toPoint: CGPointMake(screenSize.width, screenSize.height))
//
//        let animator = UIDynamicAnimator(referenceView: containerView!)
//        
//        animator.removeAllBehaviors()
//        animator.addBehavior(behaviorGravity)
//        animator.addBehavior(behaviorCollision)
//        
//        lastTransitionContext = transitionContext
//        
//        animator.delegate = self
//        lastTransitionContext?.completeTransition(true)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 300, options: UIView.AnimationOptions(), animations: {
            toVC?.view.frame.origin = CGPoint.zero
            }) { (finished) in
                transitionContext.completeTransition(true)
        }
//        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { 
//            toVC?.view.frame.origin = CGPointMake(0, 0)
//            }) { (finished) in
//                if finished {
//                    transitionContext.completeTransition(true)
//                }
//        }
    }
    
    func dismiss(_ transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containerView = transitionContext.containerView
        
        let tempView = containerView.subviews.last
        
        UIView.animate(withDuration: 0.3, animations: { 
            toVC?.view.transform = CGAffineTransform.identity
            fromVC?.view.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                if finished {
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    toVC?.view.isHidden = false
                    
                    tempView?.removeFromSuperview()
                }
        }) 
    }
}
