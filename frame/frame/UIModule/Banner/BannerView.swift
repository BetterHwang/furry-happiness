//
//  BannerView.swift
//  frame
//
//  Created by yl on 16/8/26.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit

class BannerView: UIView {
    static let PageControl_PaddingRight: CGFloat = 10
    
    var listSource: [String]? {
        didSet {
            self.refreshView()
        }
    }

    fileprivate var scrollViewBanner: UIScrollView = UIScrollView()
    fileprivate var pageControl: UIPageControl = UIPageControl()
    fileprivate var listImageView: [UIImageView] = [UIImageView]()
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customInit(frame)
    }
    
    func customInit(_ frame: CGRect) {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        scrollViewBanner.frame = self.bounds
        self.addSubview(scrollViewBanner)
        
        let pageCount = listSource == nil ? 0 : listSource!.count
        pageControl.frame = CGRect(x: self.bounds.width - CGFloat(pageCount)*10 - BannerView.PageControl_PaddingRight, y: self.bounds.height - 20, width: CGFloat(pageCount)*10, height: 20)
        self.addSubview(pageControl)
    }
    
    func refreshView() {
        
        let pageCount = listSource == nil ? 0 : listSource!.count
        pageControl.frame = CGRect(x: self.bounds.width - CGFloat(pageCount)*10 - BannerView.PageControl_PaddingRight, y: self.bounds.height - 20, width: CGFloat(pageCount)*10, height: 20)
    }
}
