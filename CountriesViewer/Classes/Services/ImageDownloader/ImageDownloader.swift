//
//  ImageDownloader.swift
//  CountriesViewer
//
//  Created by Valentin Dumareckii on 8/1/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import UIKit

// MARK: Protocol

protocol ImageDownloader {
    func downloadImage(with url: URL, completion: ((Data?) -> ())?) -> Cancellable
}

// MARK: Implementation

class ImageDownloaderImpl: ImageDownloader {
    private let dataTaskProvider: DataTaskProvider
    private let imageCache: ImageCache
    
    init(dataTaskProvider: DataTaskProvider, imageCache: ImageCache) {
        self.dataTaskProvider = dataTaskProvider
        self.imageCache = imageCache
    }
    
    func downloadImage(with url: URL, completion: ((Data?) -> ())?) -> Cancellable {
        let request = URLRequest(url: url)
        if let response = imageCache.cachedResponse(for: request) {
            completion?(response.data)
            return EmptyCancellable()
        }
        let task = dataTaskProvider.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else {
                completion?(nil)
                return
            }
            if let data = data, let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode {
                strongSelf.imageCache.storeCachedResponse(CachedURLResponse(response: httpResponse, data: data), for: request)
                completion?(data)
            } else {
                completion?(nil)
            }
        }
        task.resume()
        return task
    }
}


// MARK: Factory

class ImageDownloaderFactory {
    static func `default`() -> ImageDownloader {
        let cache = URLCache.shared
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = cache
        let session = URLSession(configuration: config)
        return ImageDownloaderImpl(dataTaskProvider: session, imageCache: cache)
    }
}
