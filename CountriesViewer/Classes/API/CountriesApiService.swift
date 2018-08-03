//
//  CountriesApiService.swift
//  CountriesViewer
//
//  Created by Valentin Dumareckii on 8/1/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import UIKit

// MARK: Protocol

protocol CountriesApiService {
    func request(token: CountriesApiToken, with completion: @escaping (Data?, URLResponse?, Error?) -> ()) -> Cancellable
}

// MARK: Implementation

class CountriesApiServiceImplementation: CountriesApiService {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request(token: CountriesApiToken, with completion: @escaping (Data?, URLResponse?, Error?) -> ()) -> Cancellable {
        
        guard let url = constructUrl(from: token) else {
            return EmptyCancellable()
        }
        
        let task: URLSessionDataTask = session.dataTask(with: url, completionHandler: completion)
        task.resume()
        return task
    }
    
    private func constructUrl(from token: CountriesApiToken) -> URL? {
        var components = URLComponents()
        components.scheme = token.scheme
        components.host = token.host
        components.path = token.path
        if !token.parameters.isEmpty {
            components.queryItems = token.parameters.map(URLQueryItem.init)
        }
        return components.url
    }
}

// MARK: Factory

class CountriesApiServiceFactory {
    static func `default`() -> CountriesApiService {
        return CountriesApiServiceImplementation(session: .shared)
    }
}
