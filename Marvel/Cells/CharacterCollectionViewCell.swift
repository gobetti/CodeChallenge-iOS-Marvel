//
//  CharacterCollectionViewCell.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 13/10/18.
//

import Foundation
import UIKit

final class CharacterCollectionViewCell: UICollectionViewCell {
    private enum LayoutConstants {
        static let cornerRadius: CGFloat = 8
        static let font = UIFont.boldSystemFont(ofSize: 12)
    }

    var name: String? {
        didSet {
            nameLabel.text = name?.uppercased()
        }
    }

    private let nameLabel: UILabel = {
        $0.font = LayoutConstants.font
        $0.textAlignment = .center
        $0.textColor = ColorPalette.text
        return $0
    }(UILabel())

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

        contentView.layer.cornerRadius = LayoutConstants.cornerRadius

        let backgroundColor: UIColor
        switch arc4random_uniform(3) {
        case 0:
            backgroundColor = ColorPalette.secondaryLight
        case 1:
            backgroundColor = ColorPalette.secondaryDark
        default:
            backgroundColor = ColorPalette.secondary
        }
        contentView.backgroundColor = backgroundColor
    }
}
