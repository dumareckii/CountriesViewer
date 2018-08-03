//
//  CountriesListViewController.swift
//  CountriesViewer
//
//  Created by Valentin Dumareckii on 8/1/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import UIKit

// MARK: CountriesListViewController

class CountriesListViewController: UITableViewController {
    
    var model = CountriesListModelFactory.default()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupTableView()
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.fetchAllCountriesIfNeeded { (progress) in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                switch progress {
                case .inProgress:
                    let activity = UIActivityIndicatorView(style: .whiteLarge)
                    activity.color = #colorLiteral(red: 0.2858578861, green: 0.5685734749, blue: 0.6255606413, alpha: 1)
                    activity.startAnimating()
                    strongSelf.tableView.backgroundView = activity
                case .success(value: let countries):
                    if countries.isEmpty {
                        strongSelf.tableView.backgroundView = strongSelf.noCountriesView()
                    } else {
                        strongSelf.tableView.backgroundView = nil
                    }
                    strongSelf.tableView.reloadData()
                case .failure(error: let error):
                    strongSelf.tableView.backgroundView = nil
                    strongSelf.showAlert(with: error)
                }
            }
        }
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5203565141, green: 0.6839788732, blue: 0.8779434419, alpha: 1)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: CountriesListCell.nibName, bundle: nil), forCellReuseIdentifier: CountriesListCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadCountries), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

// MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.countriesListData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let countryListData = model.countriesListData[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CountriesListCell.reuseIdentifier, for: indexPath) as? CountriesListCell,
            case .country(let countryData) = countryListData {
            cell.populate(with: countryData)
            return cell
        }

        return UITableViewCell()
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let model = model.countryDetailsModelForCountry(at: indexPath.row) {
            let countryDetailsController: CountryDetailsViewController = CountryDetailsViewController()
            countryDetailsController.model = model
            navigationController?.pushViewController(countryDetailsController, animated: true)
        }
    }
    
    @objc private func reloadCountries() {
        tableView.backgroundView = nil
        model.fetchAllCountries { progress in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                switch progress {
                case .inProgress: ()
                case .success(value: let countries): ()
                if countries.isEmpty {
                    strongSelf.tableView.backgroundView = strongSelf.noCountriesView()
                } else {
                    strongSelf.tableView.backgroundView = nil
                }
                strongSelf.refreshControl?.endRefreshing()
                strongSelf.tableView.reloadData()
                case .failure(error: let error):
                    strongSelf.refreshControl?.endRefreshing()
                    strongSelf.showAlert(with: error)
                }
            }
        }
    }
    
    private func showAlert(with error: NSError) {
        let alert = UIAlertController(title: error.localizedDescription, message: error.localizedFailureReason, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func noCountriesView() -> UIView {
// TODO: ADD noCountriesView
        return UIView()
    }
}
