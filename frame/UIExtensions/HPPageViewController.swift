//
//  HPPageViewController.swift
//  frame
//
//  Created by yl on 16/8/18.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit

@objc
protocol HPPageViewControllerDelegate: UIPageViewControllerDelegate {
    @objc optional func sss()
}

class HPPageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}