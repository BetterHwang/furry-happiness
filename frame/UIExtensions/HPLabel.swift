//
//  HPLabel.swift
//  frame
//
//  Created by yl on 16/7/18.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit

enum TextAlignmentVertical {
    case Top
    case Middle
    case Bottom
}

class HPLabel: UILabel {

    var textAlignmentVertical: TextAlignmentVertical = .Middle {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var textInset: UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            self.setNeedsDisplay()
        }
    }
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
        
    }
    
    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        //获取实际显示矩形
        let contentRect = UIEdgeInsetsInsetRect(bounds, textInset)
        //获取文字显示矩形
        var textRect = super.textRectForBounds(contentRect, limitedToNumberOfLines: numberOfLines)
        //根据类型修改显示的位置
        switch self.textAlignmentVertical {
        case .Top:
            textRect.origin.y = contentRect.origin.y
            break
        case .Middle:
            break
        case .Bottom:
            textRect.origin.y = contentRect.origin.y + contentRect.size.height - textRect.size.height
            break
        }
        
        return textRect
    }
    
    override func drawTextInRect(rect: CGRect) {
        let actualRect = self.textRectForBounds(rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawTextInRect(actualRect)
    }
}
