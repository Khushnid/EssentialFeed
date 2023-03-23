//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Khushnidjon on 23/03/23.
//

import EssentialFeed

protocol FeedLoadingView: AnyObject {
    func display(isLoading: Bool)
}

protocol FeedView {
    func display(feed: [FeedImage])
}

final class FeedPresenter {
    typealias Observer<T> = (T) -> Void
    var feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var feedView: FeedView?
    weak var loadingView: FeedLoadingView?
    
    func loadFeed() {
        loadingView?.display(isLoading: true)
       
        feedLoader.load { [weak self] result in
            guard let self else { return }
            
            if let feed = try? result.get() {
                self.feedView?.display(feed: feed)
            }
            
            self.loadingView?.display(isLoading: false)
        }
    }
}

