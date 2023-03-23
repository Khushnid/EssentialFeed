//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Khushnidjon on 16/03/23.
//

import UIKit

final class FeedRefreshViewController: NSObject, FeedLoadingView {
    private(set) lazy var view = loadView()
    private let presenter: FeedPresenter
    
    init(presenter: FeedPresenter) {
        self.presenter = presenter
    }
     
    @objc func refresh() {
        presenter.loadFeed()
    }
    
    func display(isLoading: Bool) {
        isLoading ? view.beginRefreshing() : view.endRefreshing()
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
