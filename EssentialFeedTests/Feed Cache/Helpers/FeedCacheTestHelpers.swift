//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Khushnidjon on 28/02/23.
//

import Foundation
import EssentialFeed

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "a description", location: "a location", url: anyURL())
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let local = models.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    return (models, local)
}

extension Date {
    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
    
    func minusFeedCacheMaxAge() -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: -feedCacheMaxAgeInDays, to: self)!
    }
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        self + seconds
    }
}
