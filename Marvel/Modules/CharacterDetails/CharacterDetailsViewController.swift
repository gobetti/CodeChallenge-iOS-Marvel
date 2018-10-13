//
//  CharacterDetailsViewController.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 13/10/18.
//

import Foundation
import UIKit

final class CharacterDetailsViewController: UIViewController {
    private let nameLabel = UILabel()

    init(character: Character) {
        nameLabel.text = character.name
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "detailsView" // UI Test
        view.backgroundColor = .white
        view.addFullSubview(nameLabel)
    }
}
