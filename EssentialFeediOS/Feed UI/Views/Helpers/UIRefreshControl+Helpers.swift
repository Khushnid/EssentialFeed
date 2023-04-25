//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Khushnidjon on 25/04/23.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
