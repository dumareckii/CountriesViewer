//
//  CountryDetailsViewController.swift
//  CountriesViewer
//
//  Created by Valentin Dumareckii on 8/1/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import UIKit

class CountryDetailsViewController: UITableViewController {

    var model: CountryDetailsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupTableView()
    }

    private func setupNavigationController() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5203565141, green: 0.6839788732, blue: 0.8779434419, alpha: 1)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: CountryDetailsFlagCell.nibName, bundle: nil), forCellReuseIdentifier: CountryDetailsFlagCell.reuseIdentifier)
        tableView.register(UINib(nibName: CountryDetailsInformationCell.nibName, bundle: nil), forCellReuseIdentifier: CountryDetailsInformationCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.countryDetailsData.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let countryDetailsData = model?.countryDetailsData[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        switch countryDetailsData {
        case .flag(let countryData):
            if let cell = tableView.dequeueReusableCell(withIdentifier: CountryDetailsFlagCell.reuseIdentifier, for: indexPath) as? CountryDetailsFlagCell {
                cell.populate(with: countryData)
                return cell
            }
        case .countryName(let countryData),
             .capital(let countryData),
             .currencies(let countryData),
             .languages(let countryData):
            if let cell = tableView.dequeueReusableCell(withIdentifier: CountryDetailsInformationCell.reuseIdentifier, for: indexPath) as? CountryDetailsInformationCell {
                cell.populate(with: countryData)
                return cell
            }
        }

        return UITableViewCell()
    }
}
