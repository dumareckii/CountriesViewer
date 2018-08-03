//
//  CountriesListDataStorage.swift
//  CountriesViewer
//
//  Created by Valentin Dumareckii on 8/1/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import UIKit

// MARK: Protocol

protocol CountriesListDataStorage {
    func save(countries: [Country])
    func getCountries() -> [Country]
    func cleanupData()
}

// MARK: Implementation

class CountriesListDataStorageImplementation: CountriesListDataStorage {
    
    private let userDefaults: UserDefaults
    static let countriesStorageKey = "Countries"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func save(countries: [Country]) {
        userDefaults.set(countries.map { $0.asString() }, forKey: CountriesListDataStorageImplementation.countriesStorageKey)
        userDefaults.synchronize()
    }
    
    func getCountries() -> [Country] {
        guard let countries = userDefaults.object(forKey: CountriesListDataStorageImplementation.countriesStorageKey) as? [String] else {
            return []
        }
        
        return countries.map{ $0.countryFromString()! }
    }
    
    func cleanupData() {
        userDefaults.removeObject(forKey: CountriesListDataStorageImplementation.countriesStorageKey)
        userDefaults.synchronize()
    }
}

// MARK: Factory

class CountriesListDataStorageFactory {
    static func `default`() -> CountriesListDataStorage {
        return CountriesListDataStorageImplementation()
    }
}
