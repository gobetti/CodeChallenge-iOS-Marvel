//
//  CharactersListCellSizeProvider.swift
//  Marvel
//
//  Created by Marcelo Gobetti on 14/10/18.
//

import Foundation
import UIKit

final class CharactersListCellSizeProvider {
    private let collectionView: UICollectionView
    private let minimumInteritemSpacing: CGFloat
    private let cellAspectRatio: CGFloat

    private var cellSize: CGSize?

    init(collectionView: UICollectionView,
         minimumInteritemSpacing: CGFloat,
         cellAspectRatio: CGFloat) {
        self.collectionView = collectionView
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.cellAspectRatio = cellAspectRatio
    }

    func invalidate() {
        cellSize = nil
    }

    func size() -> CGSize {
        if let size = cellSize {
            return size
        }

        let cellsPerRow: CGFloat = 2 // initially let's go with 2 cells regardless of screen width

        let gaps = cellsPerRow - 1
        let widthForCells = collectionView.frame.width
            - collectionView.contentInset.left
            - collectionView.contentInset.right
            - gaps * minimumInteritemSpacing
        let cellWidth = widthForCells / cellsPerRow

        let size = CGSize(width: cellWidth,
                          height: cellWidth / cellAspectRatio)
        cellSize = size
        return size
    }
}
