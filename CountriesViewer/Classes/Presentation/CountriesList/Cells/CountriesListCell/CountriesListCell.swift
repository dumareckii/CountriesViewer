//
//  CountriesListCell.swift
//  CountriesViewer
//
//  Created by Valentin Dumareckii on 8/1/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import UIKit
import PocketSVG

class CountriesListCell: UITableViewCell {
    
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryCapital: UILabel!
    @IBOutlet weak var countryCarrencies: UILabel!
    @IBOutlet weak var contentViewSVG: UIView!
    
    @IBOutlet weak var imageLoadingActivityIndicator: UIActivityIndicatorView!
    
    private var imageDownloadOperation: Cancellable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func populate(with cellData: CountriesListCellData) {
        imageLoadingActivityIndicator.startAnimating()
        imageDownloadOperation = cellData.getFlagImageData(withCompletion: { (data) in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self, let data = data else { return }
                strongSelf.imageLoadingActivityIndicator.stopAnimating()
                if let svgImageString = String(data: data, encoding: .utf8) {
                    let paths = SVGBezierPath.paths(fromSVGString: svgImageString)
                    let svgImageView = SVGImageView()
                    svgImageView.paths = paths
                    svgImageView.frame = strongSelf.contentViewSVG.bounds
                    svgImageView.contentMode = .scaleAspectFit
                    strongSelf.contentViewSVG.addSubview(svgImageView)
                }
            }
        })
        countryName.text = cellData.countryName
        countryCapital.text = "Capital - \(cellData.countryCapital)" //TODO: LOCALIZATION
        countryCarrencies.text = "Currency - \(cellData.countryCarrencies.joinWithCommas() ?? "")" //TODO: LOCALIZATION
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentViewSVG.subviews.forEach { $0.removeFromSuperview() }
        imageDownloadOperation?.cancel()
        imageDownloadOperation = nil
    }
    
    static var reuseIdentifier: String {
        return "CountriesListCell"
    }
    
    static var nibName: String {
        return "CountriesListCell"
    }
}
