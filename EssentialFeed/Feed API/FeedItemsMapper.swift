//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Khushnidjon on 13/02/23.
//

import Foundation

internal final class FeedItemsMapper {
    private struct Root: Decodable {
        let items: [Item]
         var feed: [FeedItem] { items.map { $0.item } }
    }
    
    private struct Item: Decodable {
        let id:  UUID
        let description: String?
        let location: String?
        let image: URL
        
        var item: FeedItem {
            FeedItem(
                id: id,
                description: description,
                location: location,
                imageURL: image
            )
        }
    }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(.invalidData)
        }
        
        return .success(root.feed)
    }
}