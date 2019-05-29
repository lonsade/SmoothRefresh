//
//  SmoothRefreshDataStorage.swift
//  SmoothRefresh
//
//  Created by Nikita Zhudin on 29/05/2019.
//  Copyright © 2019 Nikita Zhudin. All rights reserved.
//

public protocol SmoothRefreshDataStorage {
    
    var isEmptyDataUpdating: Bool { get }
    
    func setup(data: Any?)
}
