//
//  TypographyDemoViewModel.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 11/08/22.
//  Copyright © 2022 Augusto Avelino. All rights reserved.
//

import UIKit

protocol TypographyDemoCellDataProtocol {
    var labelText: String { get }
    var textStyle: UIFont.TextStyle { get }
}

protocol TypographyDemoViewModelProtocol: DSViewModelProtocol where ActionType == TypographyDemoAction {
    associatedtype CellData: TypographyDemoCellDataProtocol
    
    func fetchData() -> Result<Void, Error>
    
    func isListEmpty() -> Bool
    func numberOfSections() -> Int
    func numberOfCells(inSection section: Int) -> Int
    func dataForCell(atIndexPath indexPath: IndexPath) -> CellData?
}

class TypographyDemoViewModel: DSViewModel<TypographyDemoAction>, TypographyDemoViewModelProtocol {
    typealias CellData = TypographyDemoCellData
    
    // MARK: Properties
    
    let repository: TypographyRepoProtocol
    weak var coordinator: TypographyCoordinatorProtocol?
    var tableDelegate: DSTableViewModelDelegate? { delegate as? DSTableViewModelDelegate }
    
    var cellData: [TypographyDemoCellData] = []
    
    // MARK: - Life cycle
    
    init(repository: TypographyRepoProtocol, coordinator: TypographyCoordinatorProtocol) {
        self.repository = repository
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator?.performRoute(.back, animated: true)
    }
    
    // MARK: - Data
    
    func isListEmpty() -> Bool { cellData.isEmpty }
    func numberOfSections() -> Int { 1 }
    func numberOfCells(inSection section: Int) -> Int { cellData.count }
    
    func dataForCell(atIndexPath indexPath: IndexPath) -> TypographyDemoCellData? {
        guard indexPath.row < cellData.count else { return nil }
        return cellData[indexPath.row]
    }
    
    func fetchData() -> Result<Void, Error> {
        cellData = [
            ("Large Title", .largeTitle),
            ("Title 1", .title1),
            ("Title 2", .title2),
            ("Title 3", .title3),
            ("Headline", .headline),
            ("Subheadline", .subheadline),
            ("Body", .body),
            ("Callout", .callout),
            ("Footnote", .footnote),
            ("Caption 1", .caption1),
            ("Caption 2", .caption2),
        ].compactMap(TypographyDemoCellData.init)
        tableDelegate?.performTableViewUpdate(.reloadData, with: .none)
        return .success(())
    }
    
    override func performAction(_ actionType: TypographyDemoAction) {
        switch actionType {
        case .info:
            let documentation = self.buildDocumentation()
            self.coordinator?.performRoute(.info(documentation), animated: true)
        }
    }
    
    func buildDocumentation() -> Documentation {
        let doc = Documentation()
        doc.addTitle("Typography")
        doc.addHeadline("EZLabel + UIFont.TextStyle")
        doc.addParagraph("EZLabel is a subclass of UILabel. It contains useful code that eliminates a lot of boilerplate when using UIFont.TextStyle.")
        doc.addCallout("Initializing:")
        doc.addCode([
            Documentation.CodeLine(components: [
                (.keyword, "let"),
                (.plain, " label = "),
                (.type, "EZLabel"),
                (.plain, "(\t\t\t\t\t"),
            ]),
            Documentation.CodeLine(indentation: 2, components: [
                (.plain, "text: "),
                (.string, "Hello world!"),
                (.plain, ",\t\t\t\t"),
            ]),
            Documentation.CodeLine(indentation: 2, components: [
                (.plain, "textStyle: ."),
                (.property, "title2\t\t\t\t\t"),
            ]),
            Documentation.CodeLine(components: [
                (.plain, ")\t\t\t\t\t\t\t\t\t\t\t"),
            ]),
        ])
        return doc
    }
}

enum TypographyDemoAction: DSActionType {
    case info
    
    var identifier: String { "" }
}
