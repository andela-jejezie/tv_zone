//
//  CastTableViewCell.swift
//  jtv
//
//  Created by Johnson Ejezie on 11/02/2017.
//  Copyright © 2017 johnsonejezie. All rights reserved.
//

import UIKit
import Kingfisher

class CastTableViewCell: UITableViewCell {

    var cast:Cast! {
        didSet {
            configureCell(cast.name, characterOrJob: cast.character, imageURL: cast.imageURL)
        }
    }
    
    var crew:Crew! {
        didSet {
            configureCell(crew.name, characterOrJob: crew.job, imageURL: crew.imageURL)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func configureCell(_ name:String, characterOrJob:String, imageURL:String) {
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        let thumbnail:UIImageView = {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant:15).isActive = true
            $0.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 50).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
            return $0
        }(UIImageView())
        
        thumbnail.layer.cornerRadius = 25
        thumbnail.clipsToBounds = true
        
        let nameLabel: UILabel = {
            self.contentView.addSubview($0)
            $0.font =  UIFont(name: "Avenir-Medium", size: 14)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant:12).isActive = true
            $0.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant:10).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
            return $0
        }(UILabel())
        
        let characterOrJobLabel: UILabel = {
            self.contentView.addSubview($0)
            $0.font =  UIFont(name: "Avenir-Book", size: 12)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
            $0.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant:10).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
            return $0
        }(UILabel())
        
        nameLabel.text = name
        characterOrJobLabel.text = characterOrJob
        if let url = URL(string:imageURL)  {
            let resource = ImageResource(downloadURL: url, cacheKey: imageURL)
            thumbnail.kf.setImage(with: resource)
        }
        
    }

}
