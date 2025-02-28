//
//  HBCommonTabItemCell.swift
//  frame
//
//  Created by apple on 2021/5/7.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation
import SnapKit

class HBCommonTabItemCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView(view: UIView) {
        self.contentView.addSubview(view)
        view.snp.makeConstraints() { (make) in
            make.edges.equalToSuperview()
        }
    }
}
