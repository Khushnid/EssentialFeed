//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Khushnidjon on 06/02/23.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
