//
//  ProjectDetailViewModel.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 01/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import UIKit

protocol ProjectDetailCellDataProtocol {
    var iconName: String { get }
    var title: String { get }
}

protocol ProjectDetailHeaderViewDataProtocol {
    var projectName: String? { get }
    var bannerImage: UIImage? { get }
}

protocol ProjectDetailViewModelProtocol: DSViewModelProtocol where ActionType == ProjectDetailAction {
    associatedtype CellData: ProjectDetailCellDataProtocol
    associatedtype HeaderData: ProjectDetailHeaderViewDataProtocol
    
    func fetchData() -> Result<Void, Error>
    func dataForHeader() -> HeaderData?
    func numberOfSections() -> Int
    func numberOfCells(in section: Int) -> Int
    func didSelectCell(atIndexPath indexPath: IndexPath)
    func dataForCell(atIndexPath indexPath: IndexPath) -> CellData?
}

class ProjectDetailViewModel: DSViewModel<ProjectDetailAction>, ProjectDetailViewModelProtocol {
    typealias CellData = ProjectDetailCellData
    typealias HeaderData = ProjectDetailHeaderViewData
    
    // MARK: Properties
    
    let repository: ProjectDetailRepoProtocol
    weak var coordinator: ProjectCoordinatorProtocol?
    var collectionDelegate: DSCollectionViewModelDelegate? { delegate as? DSCollectionViewModelDelegate }
    
    let menuItems: [ProjectDetailMenuItem] = [.colorPalette, .strings]
    var cellData: [CellData] = []
    var headerData: HeaderData?
    
    // MARK: - Life cycle
    
    init(
        repository: ProjectDetailRepoProtocol,
        coordinator: ProjectCoordinatorProtocol
    ) {
        self.repository = repository
        self.coordinator = coordinator
        super.init()
        cellData = menuItems.compactMap(parseMenuItem(_:))
    }
    
    // MARK: - Action handling
    
    override func performAction(_ actionType: ProjectDetailAction) {
        switch actionType {
        case .rename: presentRenameAlert()
        case .chooseBanner: presentBannerController()
        case .export(let exportType): presentExportController(type: exportType)
        }
    }
    
    func performActionForMenuItem(_ menuItem: ProjectDetailMenuItem) {
        switch menuItem {
        case .colorPalette: presentColorPalette()
        case .iconography: presentIconography()
        case .typography: presentTypography()
        case .images: presentImages()
        case .strings: presentStrings()
        case .fontBook: presentFontBook()
        case .components: break
        case .wireframes: break
        }
    }
    
    // MARK: - ProjectDetailViewModelProtocol
    
    func fetchData() -> Result<Void, Error> {
        do {
            let project = try repository.fetchProject().get()
            headerData = parseProject(project)
            delegate?.reloadData()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func numberOfSections() -> Int { 1 }
    func numberOfCells(in section: Int) -> Int { cellData.count }
    func dataForCell(atIndexPath indexPath: IndexPath) -> CellData? {
        guard indexPath.item < cellData.count else { return nil }
        return cellData[indexPath.item]
    }
    
    func didSelectCell(atIndexPath indexPath: IndexPath) {
        guard indexPath.item < menuItems.count else { return }
        let menuItem = menuItems[indexPath.item]
        performActionForMenuItem(menuItem)
    }
    
    func dataForHeader() -> HeaderData? {
        return headerData
    }
    
    // MARK: - Navigation
    
    func presentRenameAlert() {
        // TODO: Corrigir renomeação de projeto
//        coordinator?.performRoute(.renameProject(delegate: self), animated: true)
    }
    
    func presentBannerController() {
        
    }
    
    func presentExportController(type: ProjectExportType) {
        
    }
    
    func presentColorPalette() {
        do {
            guard let projectID = try repository.fetchProject().get().uuid else { return }
            coordinator?.performRoute(.source(.palettePicker(projectID: projectID)), animated: true)
        } catch {
            print(error)
        }
    }
    
    func presentIconography() {
        print("NAVIGATE TO ICONOGRAPHY")
    }
    
    func presentTypography() {
        print("NAVIGATE TO TYPOGRAPHY")
    }
    
    func presentImages() {
        print("NAVIGATE TO IMAGES")
    }
    
    func presentStrings() {
        do {
            guard let projectID = try repository.fetchProject().get().uuid else { return }
            coordinator?.performRoute(.source(.strings(projectID: projectID)), animated: true)
        } catch {
            print(error)
        }
    }
    
    func presentFontBook() {
        print("NAVIGATE TO FONT BOOK")
    }
    
    // MARK: - Parsing
    
    func parseProject(_ project: Project) -> HeaderData {
        var bannerImage: UIImage?
        if let bannerData = project.bannerImage {
            bannerImage = UIImage(data: bannerData)
        }
        return ProjectDetailHeaderViewData(
            projectName: project.name,
            bannerImage: bannerImage
        )
    }
    
    func parseMenuItem(_ menuItem: ProjectDetailMenuItem) -> CellData {
        return ProjectDetailCellData(
            iconName: menuItem.iconName,
            title: menuItem.title
        )
    }
}

// MARK: - ProjectRenameAlertDelegate

// TODO: Corrigir renomeação de projeto
//extension ProjectDetailViewModel: ProjectRenameAlertDelegate {
//    func currentTextFieldText() -> String? {
//        do {
//            let project = try repository.fetchProject().get()
//            return project.name
//        } catch {
//            return nil
//        }
//    }
//
//    func alert(_ alert: UIAlertController, didRenameWith projectName: String?) {
//        do {
//            try repository.updateProject(handler: { project in
//                project.name = projectName
//            }).get()
//            try fetchData().get()
//        } catch {
//            return print(error)
//        }
//    }
//}

// MARK: - Associated types / Export

enum ProjectExportType: String {
    case folder, json
    var identifier: String { rawValue }
}

// MARK: Action type

enum ProjectDetailAction: DSActionType {
    case rename(String?)
    case chooseBanner
    case export(ProjectExportType)
    
    var identifier: String {
        switch self {
        case .rename(let newName): return "project/rename/\(newName ?? "untitled")"
        case .chooseBanner: return "project/choose_banner"
        case .export(let type): return "project/export/\(type.identifier)"
        }
    }
}

// MARK: Menu items

enum ProjectDetailMenuItem: String, CaseIterable {
    case colorPalette = "color palettes"
    case images
    case components
    case iconography
    case strings
    case wireframes
    case typography
    case fontBook = "font book"
    
    var title: String { rawValue.capitalized }
    var identifier: String { rawValue.replacingOccurrences(of: " ", with: "_") }
    var iconName: String {
        switch self {
        case .colorPalette: return "circle.hexagongrid.fill"
        case .images: return "photo.stack"
        case .components: return "square.on.square.squareshape.controlhandles"
        case .iconography: return "lightbulb.led.fill"
        case .strings: return "text.book.closed.fill"
        case .wireframes: return "app.connected.to.app.below.fill"
        case .typography: return "textformat"
        case .fontBook: return "character.book.closed.fill"
        }
    }
}
