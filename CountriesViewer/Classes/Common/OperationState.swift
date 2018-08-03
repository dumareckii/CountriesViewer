//
//  OperationState.swift
//  CountriesViewer
//
//  Created by Valentin Dumareckii on 8/1/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import UIKit

enum OperationState<V, E: Error> {
    case inProgress
    case success(value: V)
    case failure(error: E)
}
