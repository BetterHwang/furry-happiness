//
//  BaseViewModel.swift
//  frame
//
//  Created by apple on 2021/5/19.
//  Copyright © 2021 yl. All rights reserved.
//

import Foundation

protocol BaseViewModelDelegate: NSObjectProtocol {
    
}

class BaseViewModel {
    
    func onRecv(urlString: String, result: Bool, dataModel: BaseModel?, error: NSError?) {
        
    }
    
    func onArrayRecv(urlString: String, result: Bool, dataModel: [BaseModel]?, error: NSError?) {
        
    }
}
