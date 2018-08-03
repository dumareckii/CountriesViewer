//
//  CountriesListCellData.swift
//  CountriesViewer
//
//  Created by Valentin Dumareckii on 8/1/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import UIKit

struct CountriesListCellData {
    fileprivate let country: Country
    private let imageDownloader: ImageDownloader
    
    var countryName: String {
        return country.name
    }
    
    var countryCapital: String {
        return country.capital
    }
    
    var countryCarrencies: [CountryCurrency] {
        return country.currencies
    }
    
    init(country: Country, imageDownloader: ImageDownloader) {
        self.country = country
        self.imageDownloader = imageDownloader
    }
    
    func getFlagImageData(withCompletion completion: @escaping (Data?) -> ()) -> Cancellable {
        return imageDownloader.downloadImage(with: country.flag, completion: completion)
    }
}

// MARK: Factory

class CountriesListCellDataFactory {
    static func `default`(country: Country) -> CountriesListCellData {
        return CountriesListCellData(country: country, imageDownloader: ImageDownloaderFactory.default())
    }
}
