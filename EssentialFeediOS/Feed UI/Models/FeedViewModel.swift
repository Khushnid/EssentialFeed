//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Khushnidjon on 16/03/23.
//

import EssentialFeed

final class FeedViewModel {
    typealias Observer<T> = (T) -> Void
    var feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var onLoadingStateChange: Observer<Bool>?
    var onFeedLoad: Observer<[FeedImage]>?
    
    func loadFeed() {
        onLoadingStateChange?(true)
       
        feedLoader.load { [weak self] result in
            guard let self else { return }
            
            if let feed = try? result.get() {
                self.onFeedLoad?(feed)
            }
            
            self.onLoadingStateChange?(false)
        }
    }
}
