//
//  HPTextView.swift
//  frame
//
//  Created by yl on 16/7/18.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class HPTextView: UITextView {
    
    @IBInspectable var fontTextView: UIFont = UIFont.systemFont(ofSize: 16)
    @IBInspectable var placeHolderColor: UIColor = UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 1)
    @IBInspectable var placeHolderText: String? {
        didSet {
            labelPlaceHolder?.text = placeHolderText
        }
    }
    fileprivate var labelPlaceHolder: HPLabel?

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        customInit(self.bounds)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer? = nil) {
        super.init(frame: frame, textContainer: textContainer)
        
        customInit(self.bounds)
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        
        customInit(self.bounds)
    }
    
    func initPlaceHolderLabel(_ frame: CGRect) {
        if nil == labelPlaceHolder {
            labelPlaceHolder = HPLabel(frame: frame)
            self.addSubview(labelPlaceHolder!)
        }
        
        labelPlaceHolder?.textAlignmentVertical = .top
        labelPlaceHolder?.font = self.fontTextView
        labelPlaceHolder?.numberOfLines = 0
        labelPlaceHolder?.textColor = UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 1)
        labelPlaceHolder?.textInset = UIEdgeInsetsMake(self.textContainerInset.top, 5, self.textContainerInset.bottom, 5)
    }
        
    func customInit(_ frame: CGRect) {
        self.font = fontTextView
        initPlaceHolderLabel(frame)
//        initTextLengthLabel(frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HPTextView.textDidChanged), name: NSNotification.Name.UITextViewTextDidChange, object: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labelPlaceHolder?.frame = self.bounds
    }
    
    func textDidChanged() {
        if nil == self.text || 0 >= self.text?.lengthOfBytes(using: String.Encoding.utf8) {
            labelPlaceHolder?.isHidden = false
        }else {
            labelPlaceHolder?.isHidden = true
        }
    }
}
