//
//  CountryDetailsInformationCell.swift
//  CountriesViewer
//
//  Created by Valentin Dumareckii on 8/2/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import UIKit

class CountryDetailsInformationCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func populate(with cellData: CountryDetailsInformationCellData) {
        titleLabel.text = cellData.title
        descriptionLabel.text = cellData.description
    }
    
    static var reuseIdentifier: String {
        return "CountryDetailsInformationCell"
    }
    
    static var nibName: String {
        return "CountryDetailsInformationCell"
    }
}
