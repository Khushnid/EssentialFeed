//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Khushnidjon on 16/03/23.
//

import EssentialFeed
import UIKit

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: MainQueueDispatchDecorator(decoratee: feedLoader ))
        
        let feedController = FeedViewController.makeWith(
            delegate: presentationAdapter,
            title: FeedPresenter.title
        )

        presentationAdapter.presenter = FeedPresenter(
            feedView: FeedViewAdapter(
                controller: feedController,
                imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)
            ),
            loadingView: WeakReferenceVirtialProxy(feedController)
        )
        
        return feedController
    }
}

private extension FeedViewController {
    static func makeWith(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.delegate = delegate
        feedController.title = title
        return feedController
    }
}

private final class FeedViewAdapter: FeedView {
    weak var controller: FeedViewController?
    let imageLoader: FeedImageDataLoader
    
    init(controller: FeedViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map { model in
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakReferenceVirtialProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
            let view = FeedImageCellController(delegate: adapter)
            
            adapter.presenter = FeedImagePresenter(
                view: WeakReferenceVirtialProxy(view),
                imageTransformer: UIImage.init)
            
            return view
        }
    }
}

private final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {
    private let feedLoader: FeedLoader
    var presenter: FeedPresenter?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()
        
        feedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.presenter?.didFinishLoadingFeed(with: feed)
                
            case let .failure(error):
                self?.presenter?.didFinishLoadingFeed(with: error)
            }
        }
    }
}
