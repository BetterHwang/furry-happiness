//
//  ActivityViewController.swift
//  frame
//
//  Created by yl on 16/12/2.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController, UIViewControllerTransitioningDelegate, UIPopoverPresentationControllerDelegate {
    
    class func present(_ viewController: UIViewController) {
        let controller = UIStoryboard(name: "Activity", bundle: nil).instantiateViewController(withIdentifier: "ActivityViewController") as? ActivityViewController
        
        if nil != controller {
            
            controller!.transitioningDelegate = controller!
            controller!.modalPresentationStyle = .overCurrentContext
            controller!.modalTransitionStyle = .crossDissolve
            
            viewController.present(controller!, animated: true, completion: {
                
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBtnClickClose(_ sender: AnyObject) {
        self.dismiss(animated: true) { 
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HPGravityModalTransition.transitionWithType(.present, duration: 3)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HPGravityModalTransition.transitionWithType(.dismiss, duration: 3)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
