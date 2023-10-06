//
//  ProjectDetailRepository.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 01/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

protocol ProjectDetailRepoProtocol {
    func fetchProject() -> Result<Project, Error>
    func updateProject(handler: @escaping (Project) -> Void) -> Result<Void, Error>
}

class ProjectDetailRepository: ProjectDetailRepoProtocol {
    
    // MARK: Properties
    
    let project: Project
    
    // MARK: - Life cycle
    
    init(project: Project) {
        self.project = project
    }
    
    func fetchProject() -> Result<Project, Error> {
        return .success(project)
    }
    
    func updateProject(handler: @escaping (Project) -> Void) -> Result<Void, Error> {
        do {
            try AppCoreDataManager.shared.update(project, handler: {
                handler($0)
                $0.dateUpdated = Date()
            }).get()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
