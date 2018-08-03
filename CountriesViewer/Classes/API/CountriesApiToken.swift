//
//  CountriesApiToken.swift
//  CountriesViewer
//
//  Created by Valentin Dumareckii on 8/1/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import UIKit

// MARK: Protocol

protocol TargetType {
    var scheme: String  { get }
    var host: String  { get }
    var path: String  { get }
    var parameters: [String: String?] { get }
}

// MARK: Implementation

enum CountriesApiToken {
    case allCountries
}

extension CountriesApiToken: TargetType {
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "restcountries.eu"
    }
    
    var path: String {
        switch self {
        case .allCountries:
            return "/rest/v2/all"
        }
    }
    
    var parameters: [String: String?] {
        switch self {
        default:
            return [:]
        }
    }
}
