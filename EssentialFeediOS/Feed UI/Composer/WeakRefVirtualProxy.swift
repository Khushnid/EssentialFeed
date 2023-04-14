//
//  WeakReferenceVirtialProxy.swift
//  EssentialFeediOS
//
//  Created by Khushnidjon on 14/04/23.
//

import UIKit
import EssentialFeed

final class WeakReferenceVirtialProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakReferenceVirtialProxy: FeedLoadingView where T: FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakReferenceVirtialProxy: FeedImageView where T: FeedImageView, T.Image == UIImage {
    func display(_ model: FeedImageViewModel<UIImage>) {
        object?.display(model)
    }
}
