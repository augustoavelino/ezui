//
//  ProjectListViewModel.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 01/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import UIKit

// MARK: Action

enum ProjectListAction: DSActionType {
    case createProject(name: String?)
    case renameProject(indexPath: IndexPath, newName: String?)
    case deleteProject(indexPath: IndexPath)
    
    var identifier: String {
        switch self {
        case .createProject(let name): return "project-list/create/\(name ?? "UNKNOWN")"
        case .renameProject(let indexPath, let newName): return "project-list/rename/\(indexPath)/\(newName ?? "UNKNOWN")"
        case .deleteProject(let indexPath): return "project-list/delete/\(indexPath)"
        }
    }
}

// MARK: Cell data protocol

protocol ProjectListCellDataProtocol {
    var name: String { get }
    var image: UIImage? { get }
    var dateCreatedText: String? { get }
    var dateUpdatedText: String? { get }
}

// MARK: - Protocol

protocol ProjectListViewModelProtocol: DSViewModelProtocol where ActionType == ProjectListAction {
    associatedtype CellData: ProjectListCellDataProtocol
    
    func fetchData() -> Result<Void, Error>
    
    func isListEmpty() -> Bool
    func numberOfSections() -> Int
    func numberOfCells(inSection section: Int) -> Int
    func dataForCell(atIndexPath indexPath: IndexPath) -> CellData?
    
    func didSelectCell(atIndexPath indexPath: IndexPath)
}

// MARK: - View model

class ProjectListViewModel: DSViewModel<ProjectListAction>, ProjectListViewModelProtocol {
    typealias CellData = ProjectListCellData
    
    // MARK: Properties
    
    let repository: ProjectListRepoProtocol
    weak var coordinator: ProjectCoordinatorProtocol?
    var collectionDelegate: DSCollectionViewModelDelegate? { delegate as? DSCollectionViewModelDelegate }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm - dd/MM"
        return formatter
    }()
    
    var cellData: [CellData] = []
    
    // MARK: - Life cycle
    
    init(
        repository: ProjectListRepoProtocol,
        coordinator: ProjectCoordinatorProtocol
    ) {
        self.repository = repository
        self.coordinator = coordinator
    }
    
    // MARK: - Action handling
    
    override func performAction(_ actionType: ProjectListAction) {
        switch actionType {
        case .createProject(let name): createProject(named: name)
        case .renameProject(let indexPath, let newName): renameProject(atIndexPath: indexPath, newName: newName)
        case .deleteProject(let indexPath): deleteProject(atIndexPath: indexPath)
        }
    }
    
    func createProject(named projectName: String?) {
        do {
            let (_, itemIndex) = try repository.createProject(name: projectName, bannerImageData: nil).get()
            collectionDelegate?.performCollectionViewUpdate(.insert([IndexPath(item: itemIndex, section: 0)]))
            _ = try fetchData().get()
        } catch {
            print(error)
        }
    }
    
    func renameProject(atIndexPath indexPath: IndexPath, newName: String?) {
        do {
            try repository.updateProjectName(atIndex: indexPath.item, newName: newName).get()
            _ = try fetchData().get()
        } catch {
            print(error)
        }
    }
    
    func deleteProject(atIndexPath indexPath: IndexPath) {
        do {
            try repository.removeProject(atIndex: indexPath.item).get()
            let projectList = try repository.fetchProjectList().get()
            cellData = projectList.compactMap { parseProject($0) }
            collectionDelegate?.performCollectionViewUpdate(.delete([indexPath]))
        } catch {
            print(error)
        }
    }
    
    // MARK: - CRUD
    
    func fetchData() -> Result<Void, Error> {
        do {
            let projectList = try repository.fetchProjectList().get()
            cellData = projectList.compactMap { parseProject($0) }
            collectionDelegate?.performCollectionViewUpdate(.reloadData)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func isListEmpty() -> Bool { cellData.isEmpty }
    func numberOfSections() -> Int { 1 }
    func numberOfCells(inSection section: Int) -> Int { cellData.count }
    
    func dataForCell(atIndexPath indexPath: IndexPath) -> CellData? {
        guard indexPath.item < cellData.count else { return nil }
        return cellData[indexPath.item]
    }
    
    func didSelectCell(atIndexPath indexPath: IndexPath) {
        do {
            let project = try repository.project(atIndex: indexPath.item).get()
            navigateToDetail(project: project)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Navigation
    
    func navigateToDetail(project: Project) {
        coordinator?.performRoute(.detail(project: project), animated: true)
    }
    
    // MARK: - Parsing
    
    func parseProject(_ project: Project) -> CellData {
        let projectName = project.name ?? "Untitled"
        var bannerImage: UIImage?
        if let imageData = project.bannerImage {
            bannerImage = UIImage(data: imageData)
        }
        var dateCreatedText = "Created: "
        var dateUpdatedText = "Updated: "
        if let dateCreated = project.dateCreated {
            dateCreatedText += dateFormatter.string(from: dateCreated)
        }
        if let dateUpdated = project.dateUpdated {
            dateUpdatedText += dateFormatter.string(from: dateUpdated)
        }
        return ProjectListCellData(
            name: projectName,
            image: bannerImage,
            dateCreatedText: dateCreatedText,
            dateUpdatedText: dateUpdatedText
        )
    }
}
