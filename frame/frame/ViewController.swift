//
//  ViewController.swift
//  frame
//
//  Created by yl on 16/4/25.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageViewQrCode: UIImageView!
    @IBOutlet weak var textView: HPTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imageViewQrCode.image = QRCodeGenerator.qrImageForString("http://www.baidu.com/", imageSize: 80)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onBtnClickTest(sender: AnyObject) {
//        if !HPLocationManager.sharedInstance.checkEnableLocation(self) {
//            return
//        }
//        
//        HPLocationManager.sharedInstance.startLocation(.Always)
        
        NSLog("\(HPNetworkManager.sharedInstance.getNetworkLevel())")
    }

}

