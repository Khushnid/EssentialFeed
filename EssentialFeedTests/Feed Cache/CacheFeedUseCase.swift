//
//  CacheFeedUseCase.swift
//  EssentialFeedTests
//
//  Created by Khushnidjon on 19/02/23.
//

import XCTest
import EssentialFeed

class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    func save(_ items: [FeedItem], completion: @escaping (Error?) -> Void) {
        store.deleteCachedFeed { [unowned self] error in
            if error == nil {
                self.store.insert(items, timestamp: self.currentDate(), completion: completion)
            } else {
                completion(error)
            }
        }
    }
}

class FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion  = (Error?) -> Void
   
    enum RecievedMessage: Equatable {
        case deleteCachedFeed
        case insert([FeedItem], Date )
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
    
    func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion) {
        insertionsCompletions.append(completion )
        recievedMessages.append(.insert(items, timestamp))
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionsCompletions[index](nil)
    }
}

final class CacheFeedUseCase: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_ , store) = makeSUT()
        XCTAssertEqual(store.recievedMessages, [])
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem() ]
        
        sut.save(items) { _ in}
        
        XCTAssertEqual(store.recievedMessages, [.deleteCachedFeed])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem()]
        let deletionError = anyNSError()
        
        sut.save(items) { _ in }
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.recievedMessages, [.deleteCachedFeed])
    }

    func test_save_requestsNewCacheInsertionWithTimeStampOnSuccessfullDeletion() {
        let timestamp = Date()
        let (sut, store) = makeSUT(currentDate: { timestamp  })
        let items = [uniqueItem(), uniqueItem()]
        
        sut.save(items) { _ in }
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.recievedMessages, [.deleteCachedFeed, .insert(items, timestamp)])
    }
    
    func test_save_failOnDeletionError() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem()]
        let deletionError = anyNSError()
        let exp = expectation(description: "Wait for save completion")
        
        var recievedError: Error?
        
        sut.save(items) { error in
            recievedError = error
            exp.fulfill()
        }
        
        store.completeDeletion(with: deletionError)
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(recievedError as NSError?, deletionError)
    }
    
    func test_save_failOnInsertionError() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem()]
        let insertionError = anyNSError()
        let exp = expectation(description: "Wait for save completion")
        
        var recievedError: Error?
        
        sut.save(items) { error in
            recievedError = error
            exp.fulfill()
        }
        
        store.completeDeletionSuccessfully()
        store.completeInsertionSuccessfully()
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertNil(recievedError)
    }
    
    func test_save_succedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem()]
        let insertionError = anyNSError()
        let exp = expectation(description: "Wait for save completion")
        
        var recievedError: Error?
        
        sut.save(items) { error in
            recievedError = error
            exp.fulfill()
        }
        
        store.completeDeletionSuccessfully()
        store.completeInsertion(with: insertionError)
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(recievedError as NSError?, insertionError)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init,
                         file: StaticString = #filePath,
                         line: UInt = #line
    ) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(for: store, sut, file: file, line: line)
        return (sut, store)
    }
    
    private func uniqueItem() -> FeedItem {
        return FeedItem(id: UUID(), description: "a description", location: "a location", imageURL: anyURL())
    }
    
    private func anyURL() -> URL {
        URL(string: "https://any-url.com")!
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "Any Error", code: 0)
    }
}
