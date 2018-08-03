//
//  CountryDetailsFlagCellData.swift
//  CountriesViewer
//
//  Created by Valentin Dumareckii on 8/2/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import UIKit

struct CountryDetailsFlagCellData {
    fileprivate let countryFlagUrl: URL
    private let imageDownloader: ImageDownloader
    
    init(countryFlagUrl: URL, imageDownloader: ImageDownloader) {
        self.countryFlagUrl = countryFlagUrl
        self.imageDownloader = imageDownloader
    }
    
    func getFlagImageData(withCompletion completion: @escaping (Data?) -> ()) -> Cancellable {
        return imageDownloader.downloadImage(with: countryFlagUrl, completion: completion)
    }
}

// MARK: Factory

class CountryDetailsFlagCellDataFactory {
    static func `default`(countryFlagUrl: URL) -> CountryDetailsFlagCellData {
        return CountryDetailsFlagCellData(countryFlagUrl: countryFlagUrl, imageDownloader: ImageDownloaderFactory.default())
    }
}
