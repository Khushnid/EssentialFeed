//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Khushnidjon on 28/02/23.
//

import Foundation

internal final class FeedCachePolicy {
    private init() {}
    
    private static let maxCacheAgeInDays: Int = 7
    private static let calendar = Calendar(identifier: .gregorian)
    
    internal static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: FeedCachePolicy.maxCacheAgeInDays, to: timestamp) else { return false }
        return date < maxCacheAge
    }
}
