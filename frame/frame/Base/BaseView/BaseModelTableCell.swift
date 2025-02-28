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
    
    required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        clipsToBounds = true
        selectionStyle = .none
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI() {
        
    }
    
    func reloadData(_ model: T) {
        
    }
    
    class func getCell(tableView: UITableView) -> Self {
        let identifier: String = NSStringFromClass(Self.classForCoder())
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? Self
        if nil == cell {
            cell = Self.init(style: .default, reuseIdentifier: identifier)
        }
        
        return cell!
    }
    
    class func getHeight() -> CGFloat {
        return 0
    }
    
    class func getHeight(model: T) -> CGFloat {
        return 0
    }
}
