//
//  SeasonTableViewCell.swift
//  jtv
//
//  Created by Johnson Ejezie on 13/02/2017.
//  Copyright © 2017 johnsonejezie. All rights reserved.
//

import UIKit

class SeasonTableViewCell: UITableViewCell {

    var backgroundImageView:UIImageView?
    var episodeCountLabel:UILabel?
    var airdateLabel:UILabel?
    var seasonLabel:UILabel?
    
    
    var season:Season! {
        didSet {
            configureCell()
        }
    }
    
    fileprivate func configureCell() {
        episodeCountLabel?.text = "Episodes: \(season.episodeCount)"
        seasonLabel?.text = "\(season.seasonNumber)"
        airdateLabel?.text = "Premiered: " + Helpers.convertDateToString(season.airdate)
        Helpers.downloadAndSetImage(season.imageURL, imageView: backgroundImageView!, height: 150, width: contentView.frame.width)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundImageView = UIImageView()
        episodeCountLabel = UILabel()
        airdateLabel = UILabel()
        seasonLabel = UILabel()
        backgroundImageView?.contentMode = .scaleToFill
        backgroundImageView?.clipsToBounds = true
        setUpConstraint()
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        selectionStyle = .none
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func setUpConstraint() {
        
        guard let backgroundImageView = self.backgroundImageView,
        let episodeCountLabel = self.episodeCountLabel,
        let airdateLabel = self.airdateLabel,
        let seasonLabel = self.seasonLabel else {
            return
        }
        
        episodeCountLabel.font = UIFont(name: "Avenir-Medium", size: 15)
        episodeCountLabel.textColor = UIColor.white
        
        episodeCountLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        episodeCountLabel.layer.shadowOpacity = 1
        episodeCountLabel.layer.shadowRadius = 6
        
        seasonLabel.font = UIFont(name: "Avenir-Heavy", size: 22)
        seasonLabel.textColor = UIColor.white
        
        seasonLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        seasonLabel.layer.shadowOpacity = 1
        seasonLabel.layer.shadowRadius = 6
        
        airdateLabel.font = UIFont(name: "Avenir-Medium", size: 15)
        airdateLabel.textColor = UIColor.white
        
        airdateLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        airdateLabel.layer.shadowOpacity = 1
        airdateLabel.layer.shadowRadius = 6
        
        
        self.contentView.addSubview(backgroundImageView)
        self.contentView.addSubview(episodeCountLabel)
        self.contentView.addSubview(airdateLabel)
        self.contentView.addSubview(seasonLabel)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        episodeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        airdateLabel.translatesAutoresizingMaskIntoConstraints = false
        seasonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImageView.constrain(toMarginOf: contentView)
        
        episodeCountLabel.constrainToView(contentView, top: nil, trailing: 8, bottom: -8, leading: 8)
        airdateLabel.bottomAnchor.constraint(equalTo: episodeCountLabel.topAnchor, constant: -4).isActive = true
        airdateLabel.constrainToView(contentView, top: nil, trailing: 8, bottom: nil, leading: 8)
        
        seasonLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        seasonLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
