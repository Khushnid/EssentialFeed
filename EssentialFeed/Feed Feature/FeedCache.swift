//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Khushnidjon on 26/05/23.
//

import Foundation

public protocol FeedCache {
    typealias SaveResult = Result<Void, Error>
    func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void)
}
