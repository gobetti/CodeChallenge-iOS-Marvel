//
//  CharactersListCellSizeProviderTests.swift
//  MarvelTests
//
//  Created by Marcelo Gobetti on 14/10/18.
//

@testable import Marvel
import XCTest

class CharactersListCellSizeProviderTests: XCTestCase {
    var sut: CharactersListCellSizeProvider!
    var collectionView: UICollectionView!

    func testCellSizeRespectsCollectionViewSpacings() {
        let contentInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        let frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        let minimumInteritemSpacing: CGFloat = 20
        let cellAspectRatio = CGFloat(12) / CGFloat(9)

        let cellSize = size(frame: frame,
                            contentInset: contentInset,
                            minimumInteritemSpacing: minimumInteritemSpacing,
                            cellAspectRatio: cellAspectRatio)

        let widthForCells = frame.width
            - contentInset.left
            - contentInset.right
        let cellsPerRow = CGFloat(Int(widthForCells / cellSize.width))
        let totalInteritemSpacing = widthForCells - CGFloat(cellsPerRow) * cellSize.width
        let totalGaps = cellsPerRow - 1

        XCTAssertEqual(totalInteritemSpacing, totalGaps * minimumInteritemSpacing)
    }

    func testCellSizeRespectsAspectRatio() {
        let contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30)
        let frame = CGRect(x: 0, y: 0, width: 900, height: 500)
        let minimumInteritemSpacing: CGFloat = 36
        let cellAspectRatio = CGFloat(16) / CGFloat(9)

        let cellSize = size(frame: frame,
                            contentInset: contentInset,
                            minimumInteritemSpacing: minimumInteritemSpacing,
                            cellAspectRatio: cellAspectRatio)

        XCTAssertEqual(cellSize.width / cellAspectRatio, cellSize.height)
    }

    func testSameCellSizeIsReturnedInSequentialRuns() {
        let contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30)
        let frame = CGRect(x: 0, y: 0, width: 900, height: 500)
        let minimumInteritemSpacing: CGFloat = 36
        let cellAspectRatio = CGFloat(16) / CGFloat(9)

        let computeSize = {
            self.size(frame: frame,
                      contentInset: contentInset,
                      minimumInteritemSpacing: minimumInteritemSpacing,
                      cellAspectRatio: cellAspectRatio)
        }

        XCTAssertEqual(computeSize(), computeSize())
    }

    func testCellSizeIsDifferentAfterFrameChange() {
        let contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30)
        let minimumInteritemSpacing: CGFloat = 36
        let cellAspectRatio = CGFloat(16) / CGFloat(9)

        let frame1 = CGRect(x: 0, y: 0, width: 900, height: 500)
        let size1 = size(frame: frame1,
                         contentInset: contentInset,
                         minimumInteritemSpacing: minimumInteritemSpacing,
                         cellAspectRatio: cellAspectRatio)

        sut.invalidate()

        let frame2 = CGRect(x: 0, y: 0, width: 500, height: 900)
        let size2 = size(frame: frame2,
                         contentInset: contentInset,
                         minimumInteritemSpacing: minimumInteritemSpacing,
                         cellAspectRatio: cellAspectRatio)

        XCTAssertNotEqual(size1, size2)
    }

    private func size(frame: CGRect,
                      contentInset: UIEdgeInsets,
                      minimumInteritemSpacing: CGFloat,
                      cellAspectRatio: CGFloat) -> CGSize {
        if sut == nil {
            let layout = UICollectionViewFlowLayout()
            collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
            collectionView.contentInset = contentInset

            sut = CharactersListCellSizeProvider(collectionView: collectionView,
                                                 minimumInteritemSpacing: minimumInteritemSpacing,
                                                 cellAspectRatio: cellAspectRatio)
        } else {
            collectionView.frame = frame
        }
        
        return sut.size()
    }
}
