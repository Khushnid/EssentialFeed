//
//  XCTestCase+MemoryLeakDetector.swift
//  EssentialFeedTests
//
//  Created by Khushnidjon on 15/02/23.
//

import XCTest

extension XCTestCase {
    internal func trackForMemoryLeaks(for instances: AnyObject...,
                                     file: StaticString = #filePath,
                                     line: UInt = #line) {
        for instance in instances {
            addTeardownBlock { [weak instance] in
                XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak", file: file, line: line)
            }
        }
    }
}
