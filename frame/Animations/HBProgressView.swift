//
//  HBProgressView.swift
//  frame
//
//  Created by apple on 2021/4/30.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation

protocol BaseProgressViewDelegate: NSObjectProtocol {
    func progressView(progressView: BaseProgressView, didChangedProgress progress: Int)
}

protocol HBProgressProtocol: NSObjectProtocol {
    
    var progress: Int { get set }
}

class BaseProgressView: UIView {
    
    // progress 0-100
    open var progress: Int = 0 {
        willSet(value) {
            if progress == value {
                return
            }
            
            reloadProgress(progress: value)
        }
    }
    
    open weak var delegate: BaseProgressViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func reloadProgress(progress: Int) {
        if 0 > progress {
            self.progress = 0
            return
        }else if 100 < progress {
            self.progress = 100
            return
        }
        
        reloadView_Progress(progress: progress)
        delegate?.progressView(progressView: self, didChangedProgress: progress)
    }
    
    func reloadView_Progress(progress: Int) {
        
    }
}
