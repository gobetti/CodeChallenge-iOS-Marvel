//
//  CharacterDetailsViewController.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 13/10/18.
//

import Foundation
import UIKit

final class CharacterDetailsViewController: UIViewController {
    private let nameLabel: UILabel = {
        $0.textColor = ColorPalette.text
        return $0
    }(UILabel())

    init(character: Character) {
        nameLabel.text = character.name
        super.init(nibName: nil, bundle: nil)
        title = character.name?.uppercased()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "detailsView" // UI Test
        view.backgroundColor = ColorPalette.background
        view.addFullSubview(nameLabel)
    }
}
