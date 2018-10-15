//
//  UICollectionView+ReusableView.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 13/10/18.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    func register<Cell: UICollectionReusableView>(_ cellClass: Cell.Type) {
        register(cellClass, forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }

    func registerNib<Cell: UICollectionReusableView>(_ cellClass: Cell.Type) {
        register(UINib(nibName: Cell.reuseIdentifier, bundle: nil),
                 forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }
}

extension Reactive where Base: UICollectionView {
    func items<S, Cell, O>(cellType: Cell.Type = Cell.self)
        -> (O)
        -> (@escaping (Int, S.Iterator.Element, Cell) -> Void)
        -> Disposable where S: Sequence, S == O.E, Cell: UICollectionViewCell, O: ObservableType {
        return items(cellIdentifier: Cell.reuseIdentifier, cellType: cellType)
    }
}
