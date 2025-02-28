//
//  BaseModelTableViewController.swift
//  frame
//
//  Created by East on 2025/2/28.
//  Copyright © 2025 yl. All rights reserved.
//

import Foundation

class BaseModelTableViewController<T: BaseModel, C: BaseModelTableCell<T>>: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    lazy var tableViewMain: UITableView = {
        let table = UITableView.init()
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.contentInsetAdjustmentBehavior = .never
        return table
    }()
    
    lazy var listModel: [T] = {
        let list = [T]()
        return list
    }()
    
    lazy var listHeightCache: NSCache<NSString, NSNumber> = {
        let cache = NSCache<NSString, NSNumber>()
        return cache
    }()
    
    var useCacheHeight: Bool = false
    var pageIndex: Int = 0
    var pageSize: Int = AppConstants.PAGE_SIZE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewContent.addSubview(tableViewMain)
        tableViewMain.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        tableViewMain.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            self?.pageIndex = 1
            self?.loadData()
        })
        
        tableViewMain.mj_footer = MJRefreshAutoFooter.init(refreshingBlock: { [weak self] in
//            self?.pageIndex += 1
            self?.loadData()
        })
    }
    
    override func onLoadDataFinished(succeed: Bool) {
        if succeed {
            self.pageIndex += 1
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = listModel[indexPath.row]
        let height = C.getHeight(model: model)
        
        if useCacheHeight {
            listHeightCache.setObject(NSNumber.init(floatLiteral: Double(height)), forKey: model.description as NSString)
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = C.getCell(tableView: tableView)
        
        let model = listModel[indexPath.row]
        cell.dataModel = model
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = VC()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}
