//
//  HPTextViewWithLimitedLength.swift
//  frame
//
//  Created by yl on 16/7/18.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit

//高度必须大于40
class HPTextViewWithLimitedLength: UIView {
    
    @IBInspectable var isShownTextLength: Bool = false
    @IBInspectable var limitedTextLength: Int = 200 {
        didSet {
            self.initTextLengthLabel()
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var placeHolderColor: UIColor = UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 1) {
        didSet {
            self.textView.placeHolderColor = placeHolderColor
        }
    }
    @IBInspectable var placeHolderText: String? {
        didSet {
            self.textView.placeHolderText = placeHolderText
        }
    }
    var fontTextView: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            self.textView.fontTextView = fontTextView
        }
    }
    var fontLabelTextLength: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            self.labelTextLength.font = fontLabelTextLength
        }
    }
    
    fileprivate var textView: HPTextView!
    fileprivate var labelTextLength: HPLabel!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        customInit()
    }
    
    func customInit() {
        initTextView()
        initTextLengthLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HPTextView.textDidChanged), name: UITextView.textDidChangeNotification, object: self.textView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height - 30)
        labelTextLength.frame = CGRect(x: 0, y: self.bounds.size.height - 30, width: self.bounds.size.width, height: 30)
    }
    
    func initTextView() {
        if nil == textView {
            textView = HPTextView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height - 30), textContainer: nil)
            textView.backgroundColor = UIColor.blue
            self.addSubview(textView)
        }
        
        textView.frame = frame
    }
    
    func initTextLengthLabel() {
        if nil == labelTextLength {
            labelTextLength = HPLabel(frame: CGRect(x: 0, y: self.bounds.size.height - 30, width: self.bounds.size.width, height: 30))
            labelTextLength.backgroundColor = UIColor.green
            self.addSubview(labelTextLength!)
        }
        
        labelTextLength?.textAlignmentVertical = .bottom
        labelTextLength?.textAlignment = .right
        labelTextLength?.font = UIFont.systemFont(ofSize: 16)
        labelTextLength?.numberOfLines = 1
        labelTextLength?.textColor = UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 1)
        labelTextLength?.textInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 5, right: 10)
        
        if nil == self.textView?.text || 0 >= self.textView?.text?.count ?? 0 {
            labelTextLength?.text = "0/\(limitedTextLength)"
        }else {
            labelTextLength?.text = "\((self.textView.text! as NSString).length)/\(limitedTextLength)"
        }
    }
    
    func textDidChanged() {
        if nil == self.textView?.text || 0 >= self.textView?.text?.count ?? 0 {
            labelTextLength?.text = "0/\(limitedTextLength)"
        }else {
            labelTextLength?.text = "\((self.textView.text! as NSString).length)/\(limitedTextLength)"
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self.textView)
    }
}
