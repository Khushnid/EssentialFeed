//
//  CacheFeedUseCase.swift
//  EssentialFeedTests
//
//  Created by Khushnidjon on 19/02/23.
//

import XCTest

class FeedStore {
    var deleteCachedFeedCallCount = 0
}

final class CacheFeedUseCase: XCTestCase {
    
    func test() {
        let store = FeedStore()
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0 )
    }
}
