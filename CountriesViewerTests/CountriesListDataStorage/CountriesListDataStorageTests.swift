//
//  CountriesListDataStorageTests.swift
//  CountriesViewerTests
//
//  Created by Valentin Dumareckii on 8/3/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import XCTest
@testable import CountriesViewer

class CountriesListDataStorageTests: XCTestCase {
    
    var sut: CountriesListDataStorage!
    var userDefaults: UserDefaults!
    var countries: [Country]!
    
    override func setUp() {
        userDefaults = UserDefaults.init(suiteName: "test_user_defaults")
        sut = CountriesListDataStorageImplementation(userDefaults: userDefaults)
        let data = stubbedResponse(filename: "CountriesResponse")
        let decoder = JSONDecoder()
        countries = try? decoder.decode([Country].self, from: data)
    }

    override func tearDown() {
        userDefaults.removeObject(forKey: CountriesListDataStorageImplementation.countriesStorageKey)
    }
    
    func testSaveCountries_saves_providedCountries() {
        sut.save(countries: countries)
        XCTAssertEqual(userDefaults.array(forKey: CountriesListDataStorageImplementation.countriesStorageKey)?.count, countries.count)
    }
    
    func testGetCountries_returns_savedCountries() {
        sut.save(countries: countries)
        XCTAssertEqual(sut.getCountries().count, countries.count)
    }
    
    func testCleanupData_cleans_countries() {
        sut.save(countries: countries)
        sut.cleanupData()
        XCTAssertNil(userDefaults.object(forKey: CountriesListDataStorageImplementation.countriesStorageKey))
    }
}

fileprivate func stubbedResponse(filename: String) -> Data {
    let bundle = Bundle(for: CountriesListDataStorageTests.self)
    let path = bundle.path(forResource:filename, ofType: "json", inDirectory: "")!
    
    return try! Data(contentsOf: URL(fileURLWithPath: path))
}
