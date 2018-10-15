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
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.registerNib(ComicCollectionViewCell.self)
        collectionView.backgroundColor = .clear
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

        viewModel.comics(from: character)
            .drive(collectionView.rx.items(cellType: ComicCollectionViewCell.self)) { _, comic, cell in
                cell.title = comic.title
                cell.descriptionText = comic.description
            }.disposed(by: disposeBag)
    }
}
