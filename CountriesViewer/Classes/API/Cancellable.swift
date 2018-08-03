//
//  Cancellable.swift
//  CountriesViewer
//
//  Created by Valentin Dumareckii on 8/1/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import UIKit

// MARK: Protocol

protocol Cancellable {
    func cancel()
}

// MARK: Implementation

struct EmptyCancellable: Cancellable {
    func cancel() {}
}

extension URLSessionDataTask: Cancellable {}
