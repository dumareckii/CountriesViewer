//
//  DataTask.swift
//  CountriesViewer
//
//  Created by Valentin Dumareckii on 8/1/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import UIKit

// MARK: Protocol

protocol DataTask: Cancellable {
    func resume()
}

// MARK: Implementation

struct EmptyDataTask: DataTask {
    func resume() {}
    func cancel() {}
}

extension URLSessionDataTask: DataTask {}
