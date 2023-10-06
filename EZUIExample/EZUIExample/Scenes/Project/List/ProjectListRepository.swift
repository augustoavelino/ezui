//
//  ProjectListRepository.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 01/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

protocol ProjectListRepoProtocol {
    func createProject(name: String?, bannerImageData: Data?) -> Result<(Project, Int), Error>
    func fetchProjectList() -> Result<[Project], Error>
    func project(atIndex itemIndex: Int) -> Result<Project, Error>
    func updateProjectName(atIndex itemIndex: Int, newName: String?) -> Result<Void, Error>
    func updateProjectBannerImage(atIndex itemIndex: Int, newBannerImageData bannerImageData: Data?) -> Result<Void, Error>
    func removeProject(atIndex itemIndex: Int) -> Result<Void, Error>
}

class ProjectListRepository: ProjectListRepoProtocol {
    var projectList: [Project] = []
    
    func createProject(name: String?, bannerImageData: Data?) -> Result<(Project, Int), Error> {
        do {
            let project = try AppCoreDataManager.shared.create(Project.self, handler: { project in
                project.uuid = UUID().uuidString
                project.name = name
                project.dateCreated = Date()
                project.dateUpdated = Date()
                project.bannerImage = bannerImageData
            }).get()
            projectList.append(project)
            projectList = sortItems(projectList)
            AppCoreDataManager.shared.saveIfChanged()
            guard let itemIndex = projectList.firstIndex(of: project) else {
                return .failure(error(.unexpected))
            }
            return .success((project, itemIndex))
        } catch {
            return .failure(error)
        }
    }
    
    func fetchProjectList() -> Result<[Project], Error> {
        guard !projectList.isEmpty else {
            do {
                let result = try AppCoreDataManager.shared.fetch(Project.self).get()
                projectList = sortItems(result)
                return .success(projectList)
            } catch {
                return .failure(error)
            }
        }
        return .success(projectList)
    }
    
    func project(atIndex itemIndex: Int) -> Result<Project, Error> {
        guard itemIndex < projectList.count else { return .failure(error(.indexOutOfBounds)) }
        return .success(projectList[itemIndex])
    }
    
    func updateProjectName(atIndex itemIndex: Int, newName: String?) -> Result<Void, Error> {
        return updateProject(atIndex: itemIndex, handler: { project in
            project.name = newName
        })
    }
    
    func updateProjectBannerImage(atIndex itemIndex: Int, newBannerImageData bannerImageData: Data?) -> Result<Void, Error> {
        return updateProject(atIndex: itemIndex, handler: { project in
            project.bannerImage = bannerImageData
        })
    }
    
    func updateProject(atIndex itemIndex: Int, handler: @escaping (Project) -> Void) -> Result<Void, Error> {
        do {
            let project = try project(atIndex: itemIndex).get()
            try AppCoreDataManager.shared.update(project, handler: { project in
                handler(project)
                project.dateUpdated = Date()
            }).get()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func removeProject(atIndex itemIndex: Int) -> Result<Void, Error> {
        guard itemIndex < projectList.count else { return .failure(error(.indexOutOfBounds)) }
        let item = projectList.remove(at: itemIndex)
        do {
            try AppCoreDataManager.shared.delete(item).get()
            _ = try fetchProjectList().get()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func sortItems(_ itemsToSort: [Project]) -> [Project] {
        return itemsToSort.sorted(by: {
            guard let lName = $0.name,
                  let rName = $1.name else { return false }
            return lName.lowercased() < rName.lowercased()
        })
    }
}

// MARK: - AppErrorSource

extension ProjectListRepository: AppErrorSource {
    enum AppErrorType: Int, AppErrorProtocol {
        case createEmptyName = 1001
        case renameEmptyName
        case indexOutOfBounds
        case unableToCreateUUID
        case unexpected
        
        var domain: String { "ColorPaletteListRepository" }
        var code: Int { rawValue }
        var message: String {
            switch self {
            case .createEmptyName, .renameEmptyName: return "Name cannot be empty"
            case .indexOutOfBounds: return "Index out of bounds"
            case .unableToCreateUUID: return "Could not create UUID for palette"
            case .unexpected: return "An unexpected error has occurred"
            }
        }
    }
}

