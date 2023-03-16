//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Khushnidjon on 16/03/23.
//

import EssentialFeed
import UIKit

final class FeedImageCellController {
    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func view() -> UITableViewCell {
        let cell = FeedImageCell()
        cell.locationContainer.isHidden = model.location == nil
        cell.locationLabel.text = model.location
        cell.descriptionLabel.text = model.description
        cell.feedImageView.image = nil
        cell.feedImageRetryButton.isHidden = true
        cell.feedImageContainer.startShimmering()
        
        let loadImage = { [weak self, weak cell] in
            guard let self, let cell else { return }
            self.task = self.imageLoader.loadImageData(from: self.model.url) { [weak cell] result in
                guard let cell else { return }
                
                let data = try? result.get()
                let image = data.map(UIImage.init) ?? nil
                cell.feedImageView.image = image
                cell.feedImageRetryButton.isHidden = (image != nil)
                cell.feedImageContainer.stopShimmering()
            }
        }
        
        cell.onRetry = loadImage
        loadImage()
        
        return cell
    }
    
    func prelaod() {
        task = imageLoader.loadImageData(from: model.url) { _ in }
    }
    
    deinit {
        task?.cancel()
    }
}
