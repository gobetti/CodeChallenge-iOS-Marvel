//
//  ComicCollectionViewCell.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 14/10/18.
//

import UIKit

final class ComicCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = ColorPalette.text
        }
    }
    @IBOutlet private weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.textColor = ColorPalette.text
        }
    }

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = ColorPalette.secondary
    }
}
