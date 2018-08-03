//
//  CountriesListModel.swift
//  CountriesViewer
//
//  Created by Valentin Dumareckii on 8/1/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import UIKit

enum CountriesListData {
    case country(CountriesListCellData)
}

// MARK: Protocol

protocol CountriesListModel {
    var countriesListData: [CountriesListData] { get }
    func loadDataFromStorage()
    func fetchAllCountriesIfNeeded(with progressHandler: ((OperationState<[CountriesListData], NSError>) -> ())?)
    func fetchAllCountries(with progressHandler: ((OperationState<[CountriesListData], NSError>) -> ())?)
    func countryDetailsModelForCountry(at index: Int) -> CountryDetailsModel?
}

final private class CountriesListModelImplementation: CountriesListModel {
    
    private let storage: CountriesListDataStorage
    private let apiManager: CountriesApiRequestManager
    private var countries: [Country] {
        didSet {
            countriesListData = countriesListData(with: countries)
        }
    }
    private(set) var countriesListData = [CountriesListData]()
    private var currentFetchOperation: Cancellable?
    
    init(
        apiManager: CountriesApiRequestManager,
        countries: [Country] = [],
        storage: CountriesListDataStorage,
        predefinedFetchOperation: Cancellable? = nil
    ) {
        self.apiManager = apiManager
        self.countries = countries
        self.storage = storage
        self.currentFetchOperation = predefinedFetchOperation
    }
    
    func loadDataFromStorage() {
        countries = storage.getCountries()
    }
    
    func saveDataToStorage() {
        storage.save(countries: countries)
    }
    
    func fetchAllCountriesIfNeeded(with progressHandler: ((OperationState<[CountriesListData], NSError>) -> ())?) {
        progressHandler?(.inProgress)
        loadDataFromStorage()
        if countries.isEmpty {
            fetchAllCountries(with: progressHandler)
        } else {
            progressHandler?(.success(value: countriesListData))
        }
    }
    
    func fetchAllCountries(with progressHandler: ((OperationState<[CountriesListData], NSError>) -> ())?) {
        guard currentFetchOperation == nil else {
            return
        }
        progressHandler?(.inProgress)
        currentFetchOperation = apiManager.fetchAllCountries(withCompletion: { [weak self] (countries, error) in
            guard let strongSelf = self else { return }
            strongSelf.currentFetchOperation = nil
            if let error = error {
                progressHandler?(.failure(error: error as NSError))
            } else if let countries = countries {
                strongSelf.countries = countries
                strongSelf.saveDataToStorage()
                progressHandler?(.success(value: strongSelf.countriesListData))
            }
        })
    }
    
    func countryDetailsModelForCountry(at index: Int) -> CountryDetailsModel? {
        guard let country = countries[safe: index] else { return nil }
        return CountryDetailsModelFactory.default(country: country)
    }
    
    private func countriesListData(with countries:[Country]) -> [CountriesListData] {
        let data = countries.map { CountriesListData.country(CountriesListCellDataFactory.default(country: $0)) }
        return data
    }
}

// MARK: Factory

class CountriesListModelFactory {
    static func `default`() -> CountriesListModel {
        return CountriesListModelImplementation(
            apiManager: CountriesApiRequestManagerFactory.default(),
            storage: CountriesListDataStorageFactory.default()
        )
    }
}
