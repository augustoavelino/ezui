//
//  ColorPalettePNGComposer.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 27/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import UIKit

class ColorPalettePNGComposer {
    
    // MARK: Properties
    
    let palette: Palette
    let paletteColors: [PaletteColor]
    
    lazy var fileName: String = {
        guard let paletteName = palette.name else { return "ColorPalette" }
        return paletteName
    }()
    
    // MARK: - Life cycle
    
    init(palette: Palette, paletteColors: [PaletteColor]) {
        self.palette = palette
        self.paletteColors = paletteColors
    }
    
    func writeToFile(inDirectory directoryURL: URL = FileManager.default.temporaryDirectory) -> Result<URL, Error> {
        return writeToFile(named: fileName, withExtension: ".png", inDirectory: directoryURL)
    }
    
    func writeToFile(
        named fileName: String,
        withExtension fileExtension: String,
        inDirectory directoryURL: URL = FileManager.default.temporaryDirectory
    ) -> Result<URL, Error> {
        let fileURL = directoryURL.appendingPathComponent(fileName + fileExtension)
        do {
            guard let value = compose() else { return .failure(NSError(domain: "PNGComposer", code: 1001, localizedDescription: "Unexpected")) }
            try value.write(to: fileURL)
            return .success(fileURL)
        } catch {
            return .failure(error)
        }
    }
    
    func compose() -> Data? {
        let image = makeImageData()
        return image.pngData()
    }
    
    func makeImageData() -> UIImage {
        let stackView = makeStackView()
        let renderer = UIGraphicsImageRenderer(bounds: stackView.bounds)
        return renderer.image { context in
            stackView.layer.render(in: context.cgContext)
        }
    }
    
    func makeStackView() -> UIStackView {
        let colorViews = makeColorViews()
        let stackView = UIStackView(frame: CGRect(
            x: 0.0, y: 0.0,
            width: UIScreen.main.bounds.width, height: 51.33 * CGFloat(colorViews.count)
        ))
        stackView.axis = .vertical
        for colorView in colorViews {
            stackView.addArrangedSubview(colorView)
        }
        return stackView
    }
    
    func makeColorViews() -> [DSColorView] {
        return paletteColors.compactMap(makeColorView)
    }
    
    func makeColorView(for paletteColor: PaletteColor) -> DSColorView {
        let colorView = DSColorView()
        colorView.cornerRadius = 0.0
        colorView.name = paletteColor.name
        colorView.color = UIColor(rgba: Int(paletteColor.colorHex))
        return colorView
    }
}
