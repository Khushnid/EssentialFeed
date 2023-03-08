//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Khushnidjon on 06/02/23.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
