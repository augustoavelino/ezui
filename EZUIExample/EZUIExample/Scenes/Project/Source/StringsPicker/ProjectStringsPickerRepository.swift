//
//  ProjectStringsPickerRepository.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 18/09/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import CoreData

class ProjectStringsPickerRepository: StringsListRepository {
    
    // MARK: Properties
    
    let projectID: String
    let sourceType = ProjectSourceType.stringsFile.rawValue
    
    var sourceRefs: [ProjectSourceRef] = []
    var sourceIDs: [String] { sourceRefs.compactMap({ $0.sourceID }) }
    
    // MARK: - Life cycle
    
    init(projectID: String) {
        self.projectID = projectID
    }
    
    override func createStringsFile(named name: String?) -> Result<StringsFile, Error> {
        guard let name = name, !name.isEmpty else { return .failure(error(.createEmptyName)) }
        do {
            let stringsFile = try AppCoreDataManager.shared.create(StringsFile.self) { stringsFile in
                stringsFile.uuid = UUID().uuidString
                stringsFile.dateCreated = Date()
                stringsFile.dateUpdated = Date()
                stringsFile.name = name
            }.get()
            stringsFileList.append(stringsFile)
            stringsFileList = sortItems(stringsFileList)
            try createRef(forFile: stringsFile).get()
            rearrangeRefs()
            AppCoreDataManager.shared.saveIfChanged()
            return .success(stringsFile)
        } catch {
            return .failure(error)
        }
    }
    
    func createRef(forFile stringsFile: StringsFile) -> Result<Void, Error> {
        guard let fileID = stringsFile.uuid else { return .failure(error(.unexpected)) }
        do {
            let sourceRef = try AppCoreDataManager.shared.create(ProjectSourceRef.self) { [weak self] sourceRef in
                guard let self = self else { return }
                sourceRef.projectID = self.projectID
                sourceRef.sourceID = fileID
                sourceRef.sourceType = sourceType
            }.get()
            sourceRefs.append(sourceRef)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    override func fetchStringsFileList() -> Result<[StringsFile], Error> {
        guard !stringsFileList.isEmpty else {
            do {
                sourceRefs = try fetchSourceRefs().get()
                let predicate = NSPredicate(format: "uuid IN %@", sourceIDs)
                let resultItems = try AppCoreDataManager.shared.fetch(StringsFile.self, predicate: predicate).get()
                stringsFileList = sortItems(resultItems)
                rearrangeRefs()
                return .success(stringsFileList)
            } catch {
                print(error)
            }
            return .success(stringsFileList)
        }
        stringsFileList = sortItems(stringsFileList)
        rearrangeRefs()
        return .success(stringsFileList)
    }
    
    func fetchSourceRefs() -> Result<[ProjectSourceRef], Error> {
        do {
            let predicate = NSPredicate(format: "projectID == %@ AND sourceType == %@", projectID, sourceType)
            let references = try AppCoreDataManager.shared.fetch(ProjectSourceRef.self, predicate: predicate).get()
            return .success(references)
        } catch {
            return .failure(error)
        }
    }
    
    func rearrangeRefs() {
        var resultRefs: [ProjectSourceRef] = []
        for stringsFile in stringsFileList {
            if let sourceRef = sourceRefs.first(where: { $0.sourceID == stringsFile.uuid }) {
                resultRefs.append(sourceRef)
            }
        }
        sourceRefs = resultRefs
    }
}
