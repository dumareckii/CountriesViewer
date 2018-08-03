//
//  CountryDetailsModel.swift
//  CountriesViewer
//
//  Created by Valentin Dumareckii on 8/1/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import UIKit

enum CountryDetailsData {
    case flag(CountryDetailsFlagCellData)
    case countryName(CountryDetailsInformationCellData)
    case currencies(CountryDetailsInformationCellData)
    case capital(CountryDetailsInformationCellData)
    case languages(CountryDetailsInformationCellData)
}

// MARK: Protocol

protocol CountryDetailsModel {
    var countryDetailsData: [CountryDetailsData] { get }
}

// MARK: Implementation

class CountryDetailsModelImplementation: CountryDetailsModel {
    let country: Country
    private(set) var countryDetailsData = [CountryDetailsData]()
    
    init(country: Country) {
        self.country = country
        countryDetailsData = countryDetailsData(with: self.country)
    }
    
    private func countryDetailsData(with country: Country) -> [CountryDetailsData] {
        let flagData = CountryDetailsFlagCellDataFactory.default(countryFlagUrl: country.flag)
        //TODO: LOCALIZATION
        let countryName = CountryDetailsInformationCellDataFactory.default(title: "Country name", description: country.name)
        
        let currencies = CountryDetailsInformationCellDataFactory.default(title: "Currencies", description: country.currencies.joinWithCommas() ?? "")
        let capital = CountryDetailsInformationCellDataFactory.default(title: "Capital", description: country.capital)
        let languages = CountryDetailsInformationCellDataFactory.default(title: "Languages", description: country.languages.joinWithCommas() ?? "")
        
        return [CountryDetailsData.flag(flagData),
                CountryDetailsData.countryName(countryName),
                CountryDetailsData.currencies(currencies),
                CountryDetailsData.capital(capital),
                CountryDetailsData.languages(languages)]
    }
}

// MARK: Factory

class CountryDetailsModelFactory {
    static func `default`(country: Country) -> CountryDetailsModel {
        return CountryDetailsModelImplementation(country: country)
    }
}
