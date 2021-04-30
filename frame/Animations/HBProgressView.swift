//
//  HBProgressView.swift
//  frame
//
//  Created by apple on 2021/4/30.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation

protocol HBProgressViewDelegate: NSObjectProtocol {
//    func progressView(progressView: HBProgressView, didChangedProgress progress: Int)
}

protocol HBProgressProtocol {
    
}


typealias BlockChangeProgress = (_ view: HBProgressView, _ progress: Int) -> Void

class HBProgressView: UIView {
    
    // progress 0-100
    open var progress: Int = 0 {
        willSet(value) {
            if progress == value {
                return
            }
            progressDidChanged()
        }
    }
    
    open weak var delegate: HBProgressViewDelegate?
    open var blockChangeProgress: BlockChangeProgress?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func progressDidChanged() {
        
    }
    
    private func reloadView_Progress() {
        
    }
    
    class func createProgressView(_ block: @escaping BlockChangeProgress) {
        let className = NSStringFromClass(self.classForCoder())
        print("\(className)")
        
//        self.classForCoder()
    }
}

class HBCircleProgressView: HBProgressView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
