//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Khushnidjon on 28/02/23.
//

import Foundation

func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}

func anyNSError() -> NSError {
    NSError(domain: "Any Error", code: 0)
}

func anyData() -> Data {
    return Data("any data".utf8)
}
