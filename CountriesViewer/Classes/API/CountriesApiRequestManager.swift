//
//  CountriesApiRequestManager.swift
//  CountriesViewer
//
//  Created by Valentin Dumareckii on 8/1/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import UIKit

// MARK: Protocol

protocol CountriesApiRequestManager {
    func fetchAllCountries(withCompletion completion: (([Country]?, Error?) -> ())?) -> Cancellable
}

// MARK: Implementation

class CountriesApiRequestManagerImplementation: CountriesApiRequestManager {
    private let apiService: CountriesApiService
    
    init(withApiService apiService:CountriesApiService) {
        self.apiService = apiService
    }
    
    func fetchAllCountries(withCompletion completion: (([Country]?, Error?) -> ())?) -> Cancellable {
        let token = CountriesApiToken.allCountries
        return apiService.request(token: token, with: { (data, response, error) in
            let decoder = JSONDecoder()
            guard
                let dataResponse = data,
                let countries = try? decoder.decode([Country].self, from: dataResponse)
            else {
                completion?(nil, error)
                return
            }
            completion?(countries, nil)
        })
    }
}

// MARK: Factory

class CountriesApiRequestManagerFactory {
    static func `default`() -> CountriesApiRequestManager {
        return CountriesApiRequestManagerImplementation(withApiService: CountriesApiServiceFactory.default())
    }
}
