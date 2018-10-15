//
//  CharacterDetailsViewController.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 13/10/18.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class CharacterDetailsViewController: UIViewController {
    private enum LayoutConstants {
        private static let spacing: CGFloat = 8

        static let cellAspectRatio = CGFloat(3) / CGFloat(1)
        static let contentInset = UIEdgeInsets(top: spacing,
                                               left: spacing,
                                               bottom: spacing,
                                               right: spacing)
        static let minimumInteritemSpacing = spacing
        static let minimumLineSpacing = spacing
    }

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.registerNib(ComicCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = LayoutConstants.contentInset
        return collectionView
    }()
    private let disposeBag = DisposeBag()

    private let character: Character
    private let viewModel: CharacterDetailsViewModel

    init(character: Character, viewModel: CharacterDetailsViewModel) {
        self.character = character
        self.viewModel = viewModel
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
        view.addFullSubview(collectionView)

        collectionView.rx.setDelegate(self).disposed(by: disposeBag)

        viewModel.comics(from: character)
            .drive(collectionView.rx.items(cellType: ComicCollectionViewCell.self)) { _, comic, cell in
                cell.title = comic.title
                cell.descriptionText = comic.description
            }.disposed(by: disposeBag)
    }
}

extension CharacterDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstants.minimumLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstants.minimumInteritemSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset = LayoutConstants.contentInset
        let width = collectionView.frame.size.width - inset.left - inset.right
        return CGSize(width: width, height: width / LayoutConstants.cellAspectRatio)
    }
}
