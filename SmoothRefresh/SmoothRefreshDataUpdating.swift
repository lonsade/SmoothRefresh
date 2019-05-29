//
//  SmoothRefreshDataUpdating.swift
//  SmoothRefresh
//
//  Created by Nikita Zhudin on 29/05/2019.
//  Copyright © 2019 Nikita Zhudin. All rights reserved.
//

public protocol SmoothRefreshDataUpdating {
    
    /// Function for data updating. Table reload and data setting don't need to do in this function.
    ///
    /// - Parameter completion: completion after loading with data parameter (in success and reject cases)
    func updating(completion: @escaping SmoothRefreshUpdatingCompletion)
}
