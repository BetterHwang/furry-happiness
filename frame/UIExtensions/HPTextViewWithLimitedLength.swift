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
    var fontTextView: UIFont = UIFont.systemFontOfSize(16) {
        didSet {
            self.textView.fontTextView = fontTextView
        }
    }
    var fontLabelTextLength: UIFont = UIFont.systemFontOfSize(16) {
        didSet {
            self.labelTextLength.font = fontLabelTextLength
        }
    }
    
    private var textView: HPTextView!
    private var labelTextLength: HPLabel!
    
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HPTextView.textDidChanged), name: UITextViewTextDidChangeNotification, object: self.textView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 30)
        labelTextLength.frame = CGRectMake(0, self.bounds.size.height - 30, self.bounds.size.width, 30)
    }
    
    func initTextView() {
        if nil == textView {
            textView = HPTextView(frame: CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 30), textContainer: nil)
            textView.backgroundColor = UIColor.blueColor()
            self.addSubview(textView)
        }
        
        textView.frame = frame
    }
    
    func initTextLengthLabel() {
        if nil == labelTextLength {
            labelTextLength = HPLabel(frame: CGRectMake(0, self.bounds.size.height - 30, self.bounds.size.width, 30))
            labelTextLength.backgroundColor = UIColor.greenColor()
            self.addSubview(labelTextLength!)
        }
        
        labelTextLength?.textAlignmentVertical = .Bottom
        labelTextLength?.textAlignment = .Right
        labelTextLength?.font = UIFont.systemFontOfSize(16)
        labelTextLength?.numberOfLines = 1
        labelTextLength?.textColor = UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 1)
        labelTextLength?.textInset = UIEdgeInsetsMake(0, 0, 5, 10)
        
        if nil == self.textView?.text || 0 >= self.textView?.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) {
            labelTextLength?.text = "0/\(limitedTextLength)"
        }else {
            labelTextLength?.text = "\((self.textView.text! as NSString).length)/\(limitedTextLength)"
        }
    }
    
    func textDidChanged() {
        if nil == self.textView?.text || 0 >= self.textView?.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) {
            labelTextLength?.text = "0/\(limitedTextLength)"
        }else {
            labelTextLength?.text = "\((self.textView.text! as NSString).length)/\(limitedTextLength)"
        }
    }
}
