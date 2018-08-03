//
//  CountryDetailsFlagCell.swift
//  CountriesViewer
//
//  Created by Valentin Dumareckii on 8/2/18.
//  Copyright © 2018 Valentin Dumareckii. All rights reserved.
//

import UIKit
import PocketSVG

class CountryDetailsFlagCell: UITableViewCell {
    
    @IBOutlet weak var flagContentView: UIView!
    @IBOutlet weak var imageLoadingActivityIndicator: UIActivityIndicatorView!
    
    private var imageDownloadOperation: Cancellable?
    
    func populate(with cellData: CountryDetailsFlagCellData) {
        imageLoadingActivityIndicator.startAnimating()
        imageDownloadOperation = cellData.getFlagImageData(withCompletion: { (data) in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self, let data = data else { return }
                strongSelf.imageLoadingActivityIndicator.stopAnimating()
                if let svgImageString = String(data: data, encoding: .utf8) {
                    let paths = SVGBezierPath.paths(fromSVGString: svgImageString)
                    let svgImageView = SVGImageView()
                    svgImageView.paths = paths
                    svgImageView.frame = strongSelf.flagContentView.bounds
                    svgImageView.contentMode = .scaleAspectFit
                    svgImageView.translatesAutoresizingMaskIntoConstraints = false
                    strongSelf.flagContentView.addSubview(svgImageView)
                    
                    NSLayoutConstraint.activate([
                        NSLayoutConstraint(item: svgImageView, attribute: .centerX, relatedBy: .equal, toItem: strongSelf.flagContentView, attribute: .centerX, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: svgImageView, attribute: .centerY, relatedBy: .equal, toItem: strongSelf.flagContentView, attribute: .centerY, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: svgImageView, attribute: .height, relatedBy: .equal, toItem: strongSelf.flagContentView, attribute: .height, multiplier: 1, constant: 0),
                        NSLayoutConstraint(item: svgImageView, attribute: .width, relatedBy: .equal, toItem: strongSelf.flagContentView, attribute: .width, multiplier: 1, constant: 0),
                    ])
                }
            }
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        flagContentView.subviews.forEach { $0.removeFromSuperview() }
        imageDownloadOperation?.cancel()
        imageDownloadOperation = nil
    }

    static var reuseIdentifier: String {
        return "CountryDetailsFlagCell"
    }
    
    static var nibName: String {
        return "CountryDetailsFlagCell"
    }
}
