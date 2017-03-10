//
//  ItemCollectionViewCell.swift
//  jtv
//
//  Created by Johnson Ejezie on 02/01/2017.
//  Copyright © 2017 johnsonejezie. All rights reserved.
//

import UIKit
import Kingfisher

class ItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemNameLabel: UILabel!
 
    var show:Show! {
        didSet {
            configureShowCell()
        }
    }
    var movie:Movie! {
        didSet {
            configureMovieCell()
        }
    }
    
    private func configureShowCell () {
        itemNameLabel?.text = show.name
        guard let url = URL(string: show.imageURL) else {return}
        let resource = ImageResource(downloadURL: url, cacheKey: show.imageURL)
        itemImageView?.kf.setImage(with: resource)
    }
    
    private func configureMovieCell() {
        itemNameLabel?.text = movie.name
        guard let url = URL(string: movie.imageURL) else {return}
        let resource = ImageResource(downloadURL: url, cacheKey: movie.imageURL)
        itemImageView?.kf.setImage(with: resource)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
