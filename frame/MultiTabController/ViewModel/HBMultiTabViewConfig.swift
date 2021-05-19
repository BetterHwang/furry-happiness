//
//  HBMultiTabViewConfig.swift
//  frame
//
//  Created by apple on 2021/5/7.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation

class HBMultiTabViewConfig: NSObject {
    /** 是否显示底部分割线，默认为true */
    var showBottomSeparator: Bool = true
    /** 按钮之间的间距，默认为 20.0f */
    var spacingBetweenButtons: CGFloat = 20
    /** 标题文字字号大小，默认 15 号字体 */
    var titleFont: UIFont = UIFont.systemFont(ofSize: 15)
    /** 标题文字选中字号大小，默认 15 号字体 */
    var titleSelectedFont: UIFont = UIFont.systemFont(ofSize: 15)
    /** 普通状态下标题按钮文字的颜色，默认为黑色 */
    var titleColor: UIColor = UIColor.black
    /** 选中状态下标题按钮文字的颜色，默认为红色 */
    var titleSelectedColor: UIColor = UIColor.red
    /** 追踪器颜色，默认为红色 */
    var indicatorColor: UIColor = UIColor.red
    /** 追踪器高度，默认为 3.0f */
    var indicatorHeight: CGFloat = 3.0
    /** 追踪器宽度比，默认为 1.0f，与title同宽 */
    var indicatorWidthRate: CGFloat = 1.0
    /** 追踪器宽度比，默认为 1.0f，与title同宽 */
    var indicatorFixedWidth: CGFloat = 30.0
    /** 追踪器的圆角，默认为 2.0f */
    var indicatorCorner: CGFloat = 2.0
    /** 追踪器距离底部的距离，默认为 5.0f */
    var indicatorBottomDistance: CGFloat = 5.0
    /** tabView高度*/
    var tabViewHeight: CGFloat = 40.0
}
