//
//  StringsMakerViewControllerDelegate.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 30/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

protocol StringsMakerViewControllerDelegate: AnyObject {
    func stringsMaker(_ stringsMaker: StringsMakerViewController, didFinishWithKey key: String, value: String)
    func stringsMaker(_ stringsMaker: StringsMakerViewController, willDisappearAnimated animated: Bool)
}

extension StringsMakerViewControllerDelegate {
    func stringsMaker(_ stringsMaker: StringsMakerViewController, didFinishWithKey key: String, value: String) {}
    func stringsMaker(_ stringsMaker: StringsMakerViewController, willDisappearAnimated animated: Bool) {}
}
