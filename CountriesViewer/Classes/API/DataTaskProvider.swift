//
//  DataTaskProvider.swift
//  CountriesViewer
//
//  Created by Valentin Dumareckii on 8/1/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import UIKit

// MARK: Protocol

protocol DataTaskProvider {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> DataTask
}

// MARK: Implementation

extension URLSession: DataTaskProvider {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> DataTask {
        let task: URLSessionDataTask = dataTask(with: url, completionHandler: completionHandler)
        return task
    }
}
