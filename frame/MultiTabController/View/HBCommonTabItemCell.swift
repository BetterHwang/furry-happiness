//
//  HBCommonTabItemCell.swift
//  frame
//
//  Created by apple on 2021/5/7.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation

class HBCommonTabItemCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView(view: UIView) {
        self.contentView.addSubview(view)
        view.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self.contentView)
        }
    }
}
