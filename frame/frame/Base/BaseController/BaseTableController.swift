//
//  BaseTableController.swift
//  frame
//
//  Created by apple on 2021/5/19.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation

class BaseTableController: BaseViewController {
    
    var tableViewMain: UITableView!
    
    var tapGestureOnTableView: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewMain = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - navigationHeight))
        tableViewMain.separatorColor = UIColor.clear
        tableViewMain.separatorStyle = .none
        tableViewMain.showsVerticalScrollIndicator = false
        tableViewMain.dataSource = self
        tableViewMain.delegate = self
        self.view.addSubview(tableViewMain)
        
        // 有输入框的时候使用 有点击cell事件的时候不能使用会被窃取事件
        tapGestureOnTableView = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandle))
        tapGestureOnTableView.delegate = self
        tableViewMain.addGestureRecognizer(tapGestureOnTableView)
    }
    
    @objc func tapGestureHandle() {
        tableViewMain.endEditing(true)
    }
}

extension BaseTableController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == tapGestureOnTableView {
            return true
        }
        
        return false
    }
}

extension BaseTableController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
