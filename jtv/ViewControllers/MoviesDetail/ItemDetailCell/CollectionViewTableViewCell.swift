//
//  CollectionViewTableViewCell.swift
//  jtv
//
//  Created by Johnson Ejezie on 02/01/2017.
//  Copyright © 2017 johnsonejezie. All rights reserved.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {

    
    @IBOutlet var collectionView: UICollectionView!    
    override func awakeFromNib() {
        super.awakeFromNib()
        let flowyout = CustomFlowLayout()
        collectionView.collectionViewLayout = flowyout
        selectionStyle = .none
    }
}

extension CollectionViewTableViewCell {
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set {
            collectionView.contentOffset.x = newValue
        }
        
        get {
            return collectionView.contentOffset.x
        }
    }
}

class CustomFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        setupLayout()
    }
    
    override var itemSize: CGSize {
        set {
            
        }
        get {
            let numberOfColumns: CGFloat = 2
            let itemWidth = (self.collectionView!.frame.width - (numberOfColumns - 1)) / numberOfColumns
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 2
        scrollDirection = .horizontal
    }
}
