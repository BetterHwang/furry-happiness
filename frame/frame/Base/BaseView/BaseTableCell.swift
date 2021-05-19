//
//  BaseTableCell.swift
//  frame
//
//  Created by apple on 2021/5/12.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation

protocol BaseTableCellProtocol: NSObjectProtocol {
    associatedtype `Type` : BaseModel
    
    var dataModel: `Type`? { get set }
}

class BaseTableCell: UITableViewCell, BaseTableCellProtocol {
    typealias `Type` = BaseModel
    
    var dataModel: Type? {
        willSet (newValue) {
            if nil == newValue {
                return
            }
            
            reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createUI()
    }
    
    internal func createUI() {
        
    }
    
    internal func reloadData() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func getHeight() -> CGFloat {
        return 0
    }
    
    class func getCell(dataModel: Type? = nil) -> BaseTableCell {
        let cell = BaseTableCell.init(style: .default, reuseIdentifier: NSStringFromClass(BaseTableCell.classForCoder()))
        cell.dataModel = dataModel
        return cell
    }
    
    class func getCell(tableView: UITableView, dataModel: Type? = nil) -> BaseTableCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(BaseTableCell.classForCoder())) as? BaseTableCell
        if nil == cell {
            cell = BaseTableCell.init(style: .default, reuseIdentifier: NSStringFromClass(BaseTableCell.classForCoder()))
        }
        
        cell?.dataModel = dataModel
        
        return cell!
    }
}
