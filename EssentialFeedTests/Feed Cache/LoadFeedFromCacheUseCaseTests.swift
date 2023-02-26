//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Khushnidjon on 26/02/23.
//

import XCTest
import EssentialFeed

class LoadFeedFromCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.recievedMessages, [])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init,
                         file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(for: store, sut, file: file, line: line)
        return (sut, store)
    }
    
    private class FeedStoreSpy: FeedStore {
        enum RecievedMessage: Equatable {
            case deleteCachedFeed
            case insert([LocalFeedImage], Date)
        }
        
        private(set) var recievedMessages = [RecievedMessage]()
        
        private var deletionCompletions = [DeletionCompletion]()
        private var insertionsCompletions = [InsertionCompletion]()
        
        func deleteCachedFeed(completion: @escaping DeletionCompletion) {
            deletionCompletions.append(completion)
            recievedMessages.append(.deleteCachedFeed)
        }
        
        func completeDeletion(with error: Error, at index: Int = 0) {
            deletionCompletions[index](error)
        }
        
        func completeInsertion(with error: Error, at index: Int = 0) {
            insertionsCompletions[index](error)
        }
        
        func completeDeletionSuccessfully(at index: Int = 0) {
            deletionCompletions[index](nil)
        }
        
        func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
            insertionsCompletions.append(completion )
            recievedMessages.append(.insert(feed, timestamp))
        }
        
        func completeInsertionSuccessfully(at index: Int = 0) {
            insertionsCompletions[index](nil)
        }
    }
}
