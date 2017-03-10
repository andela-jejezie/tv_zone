//
//  ItemDetailTableViewCell.swift
//  jtv
//
//  Created by Johnson Ejezie on 02/01/2017.
//  Copyright © 2017 johnsonejezie. All rights reserved.
//

import UIKit
import Kingfisher

class ItemDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var itemImageView: UIImageView!
    
    
    @IBOutlet var genreLabel: UILabel!
        
    @IBOutlet var ratingLabel: UILabel!
    
    
    @IBOutlet var runtimeLabel: UILabel!
    
    
    @IBOutlet var statusLabel: UILabel!
    
    
    @IBOutlet var releaseDateLabel: UILabel!
    
    
    @IBOutlet var revenueLabel: UILabel!
    
    
    @IBOutlet var budgetLabel: UILabel!
    
    
    @IBOutlet var languageLabel: UILabel!

    
    @IBOutlet var numberOfSeasonLabel: UILabel!
    
    @IBOutlet var numberOfEpisodeLabel: UILabel!
    @IBOutlet var sypnosisLabel: UILabel!
    
    @IBOutlet var rateButton: UIButton!
    @IBOutlet var reviewButton: UIButton!
    
    @IBOutlet var watchButton: UIButton!
    
    @IBOutlet var seasonsButton: UIButton!
    @IBOutlet var subviewsWithShadow:[UIView]!
    
    fileprivate var contentType = ContentType.Movie
    
    var castTapped:((String)->())?
    var reviewTapped:((String)->())?
    var seasonTapped:((Show)->())?
    var show:Show! {
        didSet {
            contentType = .Show
            configureShowCell()
        }
    }
    var movie:Movie! {
        didSet {
            contentType = .Movie
            configureMovieCell()
        }
    }
    
    private func configureShowCell () {
        reviewButton.isHidden = true
        if show.voteAverage != 0 {
            ratingLabel.isHidden = false
            ratingLabel.text = "Rating: \(show.voteAverage)"
        }
        
        
        if show.runtime != 0 {
            runtimeLabel.isHidden = false
            runtimeLabel.text = "Runtime: \(show.runtime)"
        }
        
        if !show.status.isEmpty {
            statusLabel.isHidden = false
            statusLabel.text = "Status: \(show.status)"
        }
        
        releaseDateLabel.text = "Release date: \(Helpers.convertDateToString(show.premiered))"
        releaseDateLabel.isHidden = false
        
        if !show.spokenLanguages.isEmpty {
            languageLabel.isHidden = false
            languageLabel.text = "Language: \(show.spokenLanguages)"
        }
        
        if !show.overview.isEmpty {
            sypnosisLabel.isHidden = false
            sypnosisLabel.text = show.overview
        }
    
        
        if show.numberOfSeason != 0 {
            numberOfSeasonLabel.isHidden = false
            numberOfSeasonLabel.text = "Seasons: \(show.numberOfSeason)"
        }
        
        if show.numberOfEpisode != 0 {
            numberOfEpisodeLabel.isHidden = false
            numberOfEpisodeLabel.text = "Episodes: \(show.numberOfEpisode)"
        }
        
        guard let url = URL(string: show.imageURL) else {return}
        let resource = ImageResource(downloadURL: url, cacheKey: show.imageURL)
        itemImageView?.contentMode = .scaleAspectFill
        itemImageView?.kf.setImage(with: resource)
    }
    
    private func configureMovieCell() {
        seasonsButton.isHidden = true
        
        if movie.voteAverage != 0 {
            ratingLabel.isHidden = false
            ratingLabel.text = "Rating: \(movie.voteAverage)"
        }
        
        
        if movie.runtime != 0 {
            runtimeLabel.isHidden = false
            runtimeLabel.text = "Runtime: \(movie.runtime)"
        }
        
        if !movie.status.isEmpty {
            statusLabel.isHidden = false
            statusLabel.text = "Status: \(movie.status)"
        }
        
        releaseDateLabel.text = "Release date: \(Helpers.convertDateToString(movie.premiered))"
        
        if !movie.spokenLanguages.isEmpty {
            languageLabel.isHidden = false
            languageLabel.text = "Language: \(movie.spokenLanguages)"
        }
        
        if !movie.overview.isEmpty {
            sypnosisLabel.isHidden = false
            sypnosisLabel.text = movie.overview
        }
        
        if movie.budget != 0 {
            budgetLabel.isHidden = false
            budgetLabel.text = "Budget: $\(String(Helpers.currentFormmatter(movie.budget).characters.dropFirst()))"
        }
        
        if movie.revenue != 0 {
            revenueLabel.text = "Revenue: $\(String(Helpers.currentFormmatter(movie.revenue).characters.dropFirst()))"
            revenueLabel.isHidden = false
        }
        
        guard let url = URL(string: movie.imageURL) else {return}
        let resource = ImageResource(downloadURL: url, cacheKey: movie.imageURL)
        itemImageView?.contentMode = .scaleAspectFill
        itemImageView?.kf.setImage(with: resource)
    }
    
    
    fileprivate func addShadow() {
        for view in self.subviewsWithShadow {
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
            view.layer.shadowOpacity = 1
            view.layer.shadowRadius = 6
        }
    }
    
    @IBAction func castTapped(_ sender: Any) {
        switch contentType {
        case .Movie:
            self.castTapped?("\(self.movie.id)")
        case .Show:
            self.castTapped?("\(self.show.id)")
        }
    }
    
    @IBAction func reviewsTapped(_ sender: Any) {
        switch contentType {
        case .Movie:
            self.reviewTapped?("\(self.movie.id)")
        case .Show:
            self.reviewTapped?("\(self.show.id)")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func watchTapped(_ sender: Any) {
    }
    
    @IBAction func seasonTapped(_ sender: Any) {
        self.seasonTapped?(show)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
