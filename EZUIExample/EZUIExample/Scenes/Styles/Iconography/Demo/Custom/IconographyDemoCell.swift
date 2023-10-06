//
//  IconographyDemoCell.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 09/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

struct IconographyDemoCellData: IconographyDemoCellDataProtocol {
    let imageName: String
    let colorMode: IconographyColorMode
    let isFavorite: Bool
    
    init(imageName: String) {
        self.imageName = imageName
        colorMode = .label
        isFavorite = false
    }
    
    init(imageName: String, colorMode: IconographyColorMode, isFavorite: Bool) {
        self.imageName = imageName
        self.colorMode = colorMode
        self.isFavorite = isFavorite
    }
}

class IconographyDemoCell: EZTableViewCell {
    
    var accessoryImageView: UIImageView? { accessoryView as? UIImageView }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        imageView?.tintColor = nil
        textLabel?.text = nil
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        accessoryView = UIImageView(image: makeFavoriteImage(isFavorite: false))
        backgroundColor = .clear
    }
    
    // MARK: - Configure
    
    func configure(_ cellData: IconographyDemoCellDataProtocol) {
        configureImageView(colorMode: cellData.colorMode)
        imageView?.image = configureImage(
            UIImage(systemName: cellData.imageName),
            colorMode: cellData.colorMode
        )
        textLabel?.text = cellData.imageName
        accessoryImageView?.image = makeFavoriteImage(isFavorite: cellData.isFavorite)
    }
    
    func configureImageView(colorMode: IconographyColorMode) {
        imageView?.tintColor = colorMode == .label ? .label : nil
    }
    
    func configureImage(_ image: UIImage?, colorMode: IconographyColorMode) -> UIImage? {
        var configuration = UIImage.SymbolConfiguration(scale: .large)
        if #available(iOS 15.0, *) {
            if colorMode == .hierarchical,
               let window = (UIApplication.shared.delegate as? AppDelegate)?.window {
                configuration = UIImage.SymbolConfiguration(hierarchicalColor: window.tintColor ?? .systemBlue)
            } else if colorMode == .multicolor {
                configuration = .preferringMulticolor()
            }
        } else if #available(iOS 16.0, *) {
            if colorMode == .label || colorMode == .tinted {
                configuration = .preferringMonochrome()
            }
        }
        return image?.applyingSymbolConfiguration(configuration)
    }
    
    func makeFavoriteImage(isFavorite: Bool) -> UIImage? {
        if #available(iOS 15.0, *) {
            return makeFavoriteImageForIOS15(isFavorite)
        } else {
            return makeFavoriteImageForEarlierIOS(isFavorite)
        }
    }
    
    
    @available(iOS 15.0, *)
    func makeFavoriteImageForIOS15(_ isFavorite: Bool) -> UIImage? {
        return makeFavoriteImageForEarlierIOS(isFavorite)?.applyingSymbolConfiguration(.preferringMulticolor())
    }
    
    func makeFavoriteImageForEarlierIOS(_ isFavorite: Bool) -> UIImage? {
        return isFavorite ?
            UIImage(systemName: "heart.fill") :
            UIImage(systemName: "heart")
    }
}
