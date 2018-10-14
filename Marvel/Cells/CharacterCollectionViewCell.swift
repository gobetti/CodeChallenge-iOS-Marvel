//
//  CharacterCollectionViewCell.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 13/10/18.
//

import Foundation
import UIKit

final class CharacterCollectionViewCell: UICollectionViewCell {
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }

    private let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        contentView.addFullSubview(nameLabel)
        contentView.backgroundColor = .yellow
    }
}
