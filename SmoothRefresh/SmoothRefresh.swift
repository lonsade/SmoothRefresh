//
//  SmoothRefresh.swift
//  SmoothRefresh
//
//  Created by Nikita Zhudin on 29/05/2019.
//  Copyright © 2019 Nikita Zhudin. All rights reserved.
//

import UIKit

public typealias SmoothRefreshDataStorageAndUpdateing = SmoothRefreshDataStorage & SmoothRefreshDataUpdating
public typealias SmoothRefreshUpdatingCompletion = (Any?) -> Void
public typealias SmoothRefreshActionWhenEmptyDataUpdating = () -> Void
public typealias SmoothRefreshActionAfterDataUpdating = () -> Void
public typealias SmoothRefreshActionAfterTableUpdating = () -> Void

public class SmoothRefresh {
    
    private lazy var refreshControlView: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshed), for: .valueChanged)
        return refresh
    }()
    
    private let dataStorage: SmoothRefreshDataStorage
    private let dataUpdating: SmoothRefreshDataUpdating
    private weak var tableView: UITableView?
    
    private var isReloadedAndUpdated: Bool = true
    private var actionWhenEmptyDataUpdating: SmoothRefreshActionWhenEmptyDataUpdating?
    private var actionAfterTableUpdating: SmoothRefreshActionAfterTableUpdating?
    private var actionAfterDataUpdating: SmoothRefreshActionAfterDataUpdating?
    
    private var timer: Timer?
    
    public init(
        dataStorage: SmoothRefreshDataStorage,
        dataUpdating: SmoothRefreshDataUpdating
    ) {
        self.dataStorage = dataStorage
        self.dataUpdating = dataUpdating
    }
    
    public init(
        dataStorageAndUpdating: SmoothRefreshDataStorageAndUpdateing
    ) {
        self.dataUpdating = dataStorageAndUpdating
        self.dataStorage = dataStorageAndUpdating
    }
    
    public func setup(
        tableView: UITableView,
        actionWhenEmptyDataUpdating: SmoothRefreshActionWhenEmptyDataUpdating? = nil,
        actionAfterTableUpdating: SmoothRefreshActionAfterTableUpdating? = nil,
        actionAfterDataUpdating: SmoothRefreshActionAfterDataUpdating? = nil
    ) {
        self.tableView = tableView
        self.actionWhenEmptyDataUpdating = actionWhenEmptyDataUpdating
        self.actionAfterTableUpdating = actionAfterTableUpdating
        self.actionAfterDataUpdating = actionAfterDataUpdating
        setupRefresh()
    }
}

// Private functions

extension SmoothRefresh {
    
    private func endReloading() {
        refreshControlView.endRefreshing()
    }
    
    private func checkEndRefreshAnimation(with timer: Timer) {
        if refreshControlView.frame.origin.y == 0 {
            timer.invalidate()
            endRefreshingAnimationTriggered()
        }
    }
    
    @objc private func checkEndRefreshAnimationForLowTargetDeployment() {
        guard let timer = timer else { return }
        checkEndRefreshAnimation(with: timer)
    }
    
    @objc private func refreshed() {
        if isReloadedAndUpdated {
            setupCheckEndRefreshAnimation()
            reloadedTriggered()
        } else {
            refreshControlView.endRefreshing()
        }
    }
    
    private func setupRefresh() {
        tableView?.addSubview(refreshControlView)
    }
    
    private func setupCheckEndRefreshAnimation() {
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
                self?.checkEndRefreshAnimation(with: timer)
            }
        } else {
            timer = Timer.scheduledTimer(
                timeInterval: 0.05,
                target: self,
                selector: #selector(checkEndRefreshAnimationForLowTargetDeployment),
                userInfo: nil,
                repeats: true
            )
        }
    }
    
    private func reloadedTriggered() {
        if isReloadedAndUpdated {
            isReloadedAndUpdated = false
            dataUpdating.updating { [weak self] data in
                self?.endReloading()
                if let data = data {
                    self?.dataStorage.setup(data: data)
                    self?.actionAfterDataUpdating?()
                } else {
                    self?.isReloadedAndUpdated = true
                }
            }
        } else {
            endReloading()
        }
    }
    
    private func endRefreshingAnimationTriggered() {
        if !isReloadedAndUpdated {
            tableView?.reload { [weak self] in
                self?.isReloadedAndUpdated = true
                self?.actionAfterTableUpdating?()
            }
            if dataStorage.isEmptyDataUpdating {
                actionWhenEmptyDataUpdating?()
            }
        }
    }
}
