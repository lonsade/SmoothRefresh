//
//  TableView.swift
//  SmoothRefresh
//
//  Created by Nikita Zhudin on 29/05/2019.
//  Copyright © 2019 Nikita Zhudin. All rights reserved.
//

import UIKit

extension UITableView {
    
    func reload(completion: (() -> Void)? = nil) {
        reloadData()
        DispatchQueue.main.async {
            completion?()
        }
    }
}
