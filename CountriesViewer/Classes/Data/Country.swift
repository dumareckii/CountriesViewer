//
//  Country.swift
//  CountriesViewer
//
//  Created by Valentin Dumareckii on 8/1/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import UIKit

struct Country: Codable {
    let name: String
    let topLevelDomain: [String]
    let alpha2Code: String
    let alpha3Code: String
    let callingCodes: [String]
    let capital: String
    let altSpellings: [String]
    let region: String
    let subregion: String
    let population: UInt
    let latlng: [Float]
    let demonym: String
    let area: Float?
    let gini: Float?
    let timezones: [String]
    let borders: [String]
    let nativeName: String
    let numericCode: String?
    let currencies: [CountryCurrency]
    let languages: [CountryLanguage]
    let translations: [String : String?]
    let flag: URL
    let regionalBlocs: [CountryRegionalBlocs]
    let cioc: String?
}

struct CountryLanguage: Codable {
    let iso639_1: String?
    let iso639_2: String?
    let name: String?
    let nativeName: String?
}

struct CountryCurrency: Codable {
    let code: String?
    let name: String?
    let symbol: String?
}

struct CountryRegionalBlocs : Codable {
    let acronym: String
    let name: String
    let otherAcronyms: [String]
    let otherNames: [String]
}

extension Country {
    func asString() -> String? {
        guard let jsonData = try? JSONEncoder().encode(self),
        let string = String(data: jsonData, encoding: .utf8) else { return nil }
        return string
    }
}

extension String {
    func countryFromString() -> Country? {
        guard let jsonData = self.data(using: .utf8),
        let country = try? JSONDecoder().decode(Country.self, from: jsonData) else { return nil }
        return country
    }
}

extension Array where Element == CountryLanguage {
    func joinWithCommas() -> String? {
        var text: String?
        enumerated().forEach { index, item in
            let commaSymbolIfNeeded = index == count - 1 ? "" : ", "
            text = (text ?? "") + (item.name ?? item.nativeName ?? "") + commaSymbolIfNeeded
        }
        return text
    }
}

extension Array where Element == CountryCurrency {
    func joinWithCommas() -> String? {
        var text: String?
        enumerated().forEach { index, item in
            let commaSymbolIfNeeded = index == count - 1 ? "" : ", "
            text = (text ?? "") + (item.name ?? item.symbol ?? "") + commaSymbolIfNeeded
        }
        return text
    }
}

extension Array where Element == CountryRegionalBlocs {
    func joinWithCommas() -> String? {
        var text: String?
        enumerated().forEach { index, item in
            let commaSymbolIfNeeded = index == count - 1 ? "" : ", "
            text = (text ?? "") + item.name + commaSymbolIfNeeded
        }
        return text
    }
}
