//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Khushnidjon on 13/02/23.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}
