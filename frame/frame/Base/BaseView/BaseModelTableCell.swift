//
//  BaseModelTableCell.swift
//  frame
//
//  Created by East on 2025/2/28.
//  Copyright © 2025 yl. All rights reserved.
//

import Foundation

class BaseModelTableCell<T: BaseModel>: UITableViewCell {
    
    var dataModel: T? {
        didSet {
            guard let model = dataModel else {
                return
            }
            
            reloadData(model)
        }
    }
    
    func reloadData(_ model: T) {
        
    }
}
