//
//  SourceMenuViewModel.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 10/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import UIKit

struct SourceMenuSectionData {
    let title: String?
    let cellData: [DSMenuItemCellData]
}

protocol SourceMenuViewModelProtocol: DSViewModelProtocol {
    func updateTintColor(_ color: UIColor?)
    func numberOfSections() -> Int
    func titleForSection(_ section: Int) -> String?
    func numberOfCells(inSection section: Int) -> Int
    func dataForCell(atIndexPath indexPath: IndexPath) -> DSMenuItemCellData?
    func didSelectCell(atIndexPath indexPath: IndexPath)
}

class SourceMenuViewModel: DSViewModel<SourceMenuAction>, SourceMenuViewModelProtocol {
    
    // MARK: Properties
    
    var sectionData: [SourceMenuSectionData] = []
    var tintColor: UIColor?
    
    // MARK: Coordinator
    
    weak var coordinator: SourceMenuCoordinatorProtocol?
    
    // MARK: - Life cycle
    
    init(coordinator: SourceMenuCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator?.performRoute(.back, animated: true)
    }
    
    // MARK: - SourceMenuViewModelProtocol
    
    func updateTintColor(_ color: UIColor?) {
        tintColor = color
        reloadSectionData()
    }
    
    func numberOfSections() -> Int {
        return sectionData.count
    }
    
    func titleForSection(_ section: Int) -> String? {
        guard section < sectionData.count else { return nil }
        return sectionData[section].title
    }
    
    func numberOfCells(inSection section: Int) -> Int {
        guard section < sectionData.count else { return 0 }
        return sectionData[section].cellData.count
    }
    
    func dataForCell(atIndexPath indexPath: IndexPath) -> DSMenuItemCellData? {
        guard indexPath.section < sectionData.count,
              indexPath.row < sectionData[indexPath.section].cellData.count else { return nil }
        return sectionData[indexPath.section].cellData[indexPath.row]
    }
    
    func didSelectCell(atIndexPath indexPath: IndexPath) {
        switch indexPath.section {
        case 0: performResourcesRoute(indexPath.row)
        case 1: performStylesRoute(indexPath.row)
        case 2: performCompositionRoute(indexPath.row)
        default: return
        }
    }
    
    func performResourcesRoute(_ cellRow: Int) {
        switch cellRow {
        case 0: coordinator?.performRoute(.resources(.strings), animated: true)
        default: return
        }
    }
    
    func performStylesRoute(_ cellRow: Int) {
        switch cellRow {
        case 0: coordinator?.performRoute(.styles(.colorPalette), animated: true)
        case 1: coordinator?.performRoute(.styles(.typography), animated: true)
        case 2: coordinator?.performRoute(.styles(.iconography), animated: true)
        default: return
        }
    }
    
    func performCompositionRoute(_ cellRow: Int) {
        switch cellRow {
        case 1: coordinator?.performRoute(.composition(.viewLayout), animated: true)
        default: return
        }
    }
    
    func reloadSectionData() {
        sectionData = [
            SourceMenuSectionData(
                title: .appString(.menu(.resourcesSectionTitle)),
                cellData: [
                    makeMenuItem(iconName: "text.book.closed.fill", title: .appString(.menu(.stringsTitle))),
                    makeMenuItem(iconName: "photo.stack", title: .appString(.menu(.imagesTitle))),
                ]
            ),
            SourceMenuSectionData(
                title: .appString(.menu(.stylesSectionTitle)),
                cellData: [
                    makeMenuItem(iconName: "circle.hexagongrid.fill", title: .appString(.menu(.colorPaletteTitle))),
                    makeMenuItem(iconName: "textformat", title: .appString(.menu(.typographyTitle))),
                    makeMenuItem(iconName: "lightbulb.led.fill", title: .appString(.menu(.iconographyTitle))),
                ]
            ),
            SourceMenuSectionData(
                title: .appString(.menu(.compositionSectionTitle)),
                cellData: [
                    makeMenuItem(iconName: "square.on.square.squareshape.controlhandles", hierarchicalColor: tintColor, title: .appString(.menu(.viewComposerTitle))),
                    makeMenuItem(iconName: "squareshape.controlhandles.on.squareshape.controlhandles", hierarchicalColor: tintColor, title: .appString(.menu(.viewLayoutTitle))),
                ]
            ),
        ]
    }
    
    func makeMenuItem(iconName: String, hierarchicalColor: UIColor? = nil, title: String) -> DSMenuItemCellData {
        var image = UIImage(systemName: iconName)
        if #available(iOS 15.0, *) {
            if let hierarchicalColor = hierarchicalColor {
                image = image?.applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(hierarchicalColor: hierarchicalColor))
            } else {
                image = image?.applyingSymbolConfiguration(UIImage.SymbolConfiguration.preferringMulticolor())
            }
        }
        return DSMenuItemCellData(
            icon: image,
            title: title
        )
    }
}

// MARK: - Action type

enum SourceMenuAction: DSActionType {
    var identifier: String { "" }
}
