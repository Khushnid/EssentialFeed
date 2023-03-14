//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Khushnidjon on 14/03/23.
//

import EssentialFeed
import UIKit

final public class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    
    public convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    @objc func load() {
        refreshControl?.beginRefreshing()
        
        loader?.load { [weak self] _ in
            guard let self else { return }
            self.refreshControl?.endRefreshing()
        }
    }
}
