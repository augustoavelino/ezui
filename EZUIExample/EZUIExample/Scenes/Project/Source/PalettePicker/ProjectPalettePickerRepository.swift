//
//  ProjectPalettePickerRepository.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 06/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import CoreData

class ProjectPalettePickerRepository: ColorPaletteListRepository {
    
    // MARK: Properties
    
    let projectID: String
    let sourceType = ProjectSourceType.colorPalette.rawValue
    
    var sourceRefs: [ProjectSourceRef] = []
    var sourceIDs: [String] { sourceRefs.compactMap({ $0.sourceID }) }
    
    // MARK: - Life cycle
    
    init(projectID: String) {
        self.projectID = projectID
    }
    
    override func createPalette(named name: String?) -> Result<(Palette, Int), Error> {
        guard let name = name, !name.isEmpty else { return .failure(error(.createEmptyName)) }
        do {
            let palette = try AppCoreDataManager.shared.create(Palette.self) { palette in
                palette.id = UUID().uuidString
                palette.dateCreated = Date()
                palette.dateUpdated = Date()
                palette.name = name
            }.get()
            paletteList.append(palette)
            paletteList = sortItems(paletteList)
            try createRef(forPalette: palette).get()
            rearrangeRefs()
            AppCoreDataManager.shared.saveIfChanged()
            guard let itemIndex = paletteList.firstIndex(of: palette) else {
                return .failure(error(.unexpected))
            }
            return .success((palette, itemIndex))
        } catch {
            return .failure(error)
        }
    }
    
    func createRef(forPalette palette: Palette) -> Result<Void, Error> {
        guard let paletteID = palette.id else { return .failure(error(.unexpected)) }
        do {
            let sourceRef = try AppCoreDataManager.shared.create(ProjectSourceRef.self) { [weak self] sourceRef in
                guard let self = self else { return }
                sourceRef.projectID = self.projectID
                sourceRef.sourceID = paletteID
                sourceRef.sourceType = sourceType
            }.get()
            sourceRefs.append(sourceRef)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    override func fetchPaletteList() -> Result<[Palette], Error> {
        guard !paletteList.isEmpty else {
            do {
                sourceRefs = try fetchSourceRefs().get()
                let predicate = NSPredicate(format: "id IN %@", sourceIDs)
                let resultItems = try AppCoreDataManager.shared.fetch(Palette.self, predicate: predicate).get()
                paletteList = sortItems(resultItems)
                rearrangeRefs()
                return .success(paletteList)
            } catch {
                return .failure(error)
            }
        }
        paletteList = sortItems(paletteList)
        rearrangeRefs()
        return .success(paletteList)
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
        for palette in paletteList {
            if let sourceRef = sourceRefs.first(where: { $0.sourceID == palette.id }) {
                resultRefs.append(sourceRef)
            }
        }
        sourceRefs = resultRefs
    }
}
