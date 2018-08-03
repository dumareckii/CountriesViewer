//
//  CountryDetailsInformationCellData.swift
//  CountriesViewer
//
//  Created by Valentin Dumareckii on 8/2/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import UIKit

struct CountryDetailsInformationCellData {
    
    let title: String
    let description: String
    
    init(with title:String, and description: String) {
        self.title = title
        self.description = description
    }
}

// MARK: Factory

class CountryDetailsInformationCellDataFactory {
    static func `default`(title: String, description: String) -> CountryDetailsInformationCellData {
        return CountryDetailsInformationCellData(with: title, and: description)
    }
}
