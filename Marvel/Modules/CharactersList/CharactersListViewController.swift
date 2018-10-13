//
//  CharactersListViewController.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 12/10/18.
//

import RxCocoa
import RxSwift
import UIKit

final class CharactersListViewController: UIViewController {
    typealias OnCharacterSelected = (Character) -> Void

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CharacterCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    private let disposeBag = DisposeBag()

    private let viewModel: CharactersListViewModel

    init(viewModel: CharactersListViewModel,
         onCharacterSelected: @escaping OnCharacterSelected) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        collectionView.rx.modelSelected(Character.self)
            .bind(onNext: onCharacterSelected)
            .disposed(by: disposeBag)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addFullSubview(collectionView)

        viewModel.characters()
            .drive(collectionView.rx.items(cellType: CharacterCollectionViewCell.self)) { _, character, cell in
                cell.name = character.name
            }.disposed(by: disposeBag)
    }
}
