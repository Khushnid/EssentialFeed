//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Khushnidjon on 02/05/23.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
