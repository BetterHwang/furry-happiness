//
//  HPLabel.swift
//  frame
//
//  Created by yl on 16/7/18.
//  Copyright © 2016年 yl. All rights reserved.
//

import UIKit

enum TextAlignmentVertical {
    case top
    case middle
    case bottom
}

class HPLabel: UILabel {

    var textAlignmentVertical: TextAlignmentVertical = .middle {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var textInset: UIEdgeInsets = UIEdgeInsets.zero {
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
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        //获取实际显示矩形
        let contentRect = bounds.inset(by: textInset)
        //获取文字显示矩形
        var textRect = super.textRect(forBounds: contentRect, limitedToNumberOfLines: numberOfLines)
        //根据类型修改显示的位置
        switch self.textAlignmentVertical {
        case .top:
            textRect.origin.y = contentRect.origin.y
            break
        case .middle:
            break
        case .bottom:
            textRect.origin.y = contentRect.origin.y + contentRect.size.height - textRect.size.height
            break
        }
        
        return textRect
    }
    
    override func drawText(in rect: CGRect) {
        let actualRect = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: actualRect)
    }
}
