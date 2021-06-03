//
//  HPPlayerViewController.swift
//  frame
//
//  Created by apple on 2021/6/1.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation
import AVKit

class HPPlayerViewController: BaseViewController {
    
    lazy var player: AVPlayerViewController = {
        let player = AVPlayerViewController.init()
        
        return player
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChild(player)
        self.view.addSubview(player.view)
        player.view.mas_makeConstraints { make in
            make?.edges.equalTo()(player.view)
        }
    }
}
