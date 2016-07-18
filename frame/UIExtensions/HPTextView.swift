//
//  HPTextView.swift
//  frame
//
//  Created by yl on 16/7/18.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit

class HPTextView: UITextView {
    
    @IBInspectable var fontTextView: UIFont = UIFont.systemFontOfSize(16)
    @IBInspectable var placeHolderColor: UIColor = UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 1)
    @IBInspectable var placeHolderText: String? {
        didSet {
            labelPlaceHolder?.text = placeHolderText
        }
    }
    private var labelPlaceHolder: HPLabel?

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
    
    func initPlaceHolderLabel(frame: CGRect) {
        if nil == labelPlaceHolder {
            labelPlaceHolder = HPLabel(frame: frame)
            self.addSubview(labelPlaceHolder!)
        }
        
        labelPlaceHolder?.textAlignmentVertical = .Top
        labelPlaceHolder?.font = self.fontTextView
        labelPlaceHolder?.numberOfLines = 0
        labelPlaceHolder?.textColor = UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 1)
        labelPlaceHolder?.textInset = UIEdgeInsetsMake(self.textContainerInset.top, 5, self.textContainerInset.bottom, 5)
    }
        
    func customInit(frame: CGRect) {
        self.font = fontTextView
        initPlaceHolderLabel(frame)
//        initTextLengthLabel(frame)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HPTextView.textDidChanged), name: UITextViewTextDidChangeNotification, object: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labelPlaceHolder?.frame = self.bounds
    }
    
    func textDidChanged() {
        if nil == self.text || 0 >= self.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) {
            labelPlaceHolder?.hidden = false
        }else {
            labelPlaceHolder?.hidden = true
        }
    }
}
