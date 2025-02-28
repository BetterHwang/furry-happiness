//
//  LineProgressView.swift
//  frame
//
//  Created by East on 2025/2/28.
//  Copyright © 2025 yl. All rights reserved.
//

import Foundation

protocol ProgressProtocol: NSObjectProtocol {
    var progress: Float { set get }
}

class LineProgressView: UIView, ProgressProtocol {
    
    var progress: Float = 0 {
        didSet {
            reloadProgress(progress)
        }
    }
    
    lazy var viewProgress: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewProgress.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        addSubview(viewProgress)
    }
    
    private func reloadProgress(_ progress: Float) {
        let temp = min(1, max(0, progress))
        if progress < 1 {
            self.isHidden = false
        }
        
        viewProgress.layer.removeAllAnimations()
        
        UIView.animate(withDuration: 1) { [weak self] in
            if nil == self {
                return
            }
            self?.viewProgress.frame = CGRect(x: 0, y: 0, width: self!.width * CGFloat(temp), height: self!.height)
        } completion: { [weak self] _ in
            if 1 <= progress {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.isHidden = true
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LineProgressView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.viewProgress.frame = CGRect(x: 0, y: 0, width: self.width * CGFloat(self.progress), height: self.height)
//        self.setCornerRadius(width: self.height / 2)
        self.viewProgress.layer.removeAllAnimations()
        if 1 <= self.progress {
            self.isHidden = true
        }
    }
}
