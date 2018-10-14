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
    private enum LayoutConstants {
        private static let spacing: CGFloat = 16

        static let cellAspectRatio = CGFloat(10) / CGFloat(8)
        static let contentInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        static let minimumInteritemSpacing = spacing
        static let minimumLineSpacing = spacing
    }

    typealias OnCharacterSelected = (Character) -> Void

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CharacterCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = LayoutConstants.contentInset
        return collectionView
    }()
    private lazy var cellSizeProvider =
        CharactersListCellSizeProvider(collectionView: self.collectionView,
                                       minimumInteritemSpacing: LayoutConstants.minimumInteritemSpacing,
                                       cellAspectRatio: LayoutConstants.cellAspectRatio)
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

        collectionView.rx.setDelegate(self).disposed(by: disposeBag)

        viewModel.characters()
            .drive(collectionView.rx.items(cellType: CharacterCollectionViewCell.self)) { _, character, cell in
                cell.name = character.name
            }.disposed(by: disposeBag)
    }
}

extension CharactersListViewController: UICollectionViewDelegateFlowLayout {
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
        return cellSizeProvider.size()
    }
}
