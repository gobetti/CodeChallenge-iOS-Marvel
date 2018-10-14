//
//  GlobalAppearance.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 14/10/18.
//

import Foundation
import UIKit

enum GlobalAppearance {
    static func apply() {
        UINavigationBar.appearance().barTintColor = ColorPalette.primary
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: ColorPalette.text]
        UINavigationBar.appearance().tintColor = ColorPalette.text
    }
}
