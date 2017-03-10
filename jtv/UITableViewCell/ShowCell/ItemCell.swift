//
//  ShowCell.swift
//  jtv
//
//  Created by Johnson Ejezie on 14/12/2016.
//  Copyright © 2016 johnsonejezie. All rights reserved.
//

import UIKit
import Kingfisher

final class ItemCell: UITableViewCell {
    
    private var title:UILabel?
    private var summary:UILabel?
    private var readMoreButton: UIButton?
    private var posterImageView:UIImageView?
    private var containerView: UIView?
    private var bottomView:UIView?
    private var type:ContentType = .Show
    
    var show:Show! {
        didSet {
            self.type = .Show
            configureShowCell()
        }
    }
    var movie:Movie! {
        didSet {
            self.type = .Movie
            configureMovieCell()
        }
    }
    
    private func configureShowCell () {
        summary?.text = show.overview
        title?.text = show.name
        Helpers.downloadAndSetImage(show.imageURL, imageView: posterImageView!, height: 250, width: posterImageView!.frame.width)
    }
    
    private func configureMovieCell() {
        summary?.text = movie.overview
        title?.text = movie.name
        Helpers.downloadAndSetImage(movie.imageURL, imageView: posterImageView!, height: 250, width: posterImageView!.frame.width)
    }
    
    @objc private func readMoreButtonTapped(_ sender:UIButton) {
        
        switch self.type {
        case .Show:
            Helpers.didSelectShow?(self.show)
        case .Movie:
            Helpers.didSelectMovie?(self.movie)
        }
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        title = UILabel()
        summary = UILabel()
        posterImageView = UIImageView()
        posterImageView?.contentMode = .scaleToFill
        posterImageView?.clipsToBounds = true
        readMoreButton = UIButton()
        readMoreButton?.addTarget(self, action: #selector(self.readMoreButtonTapped(_:)), for: .touchUpInside)
        containerView = UIView()
        bottomView = UIView()
        setupUI()
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        selectionStyle = .none
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.containerView?.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        self.containerView?.layer.borderWidth = 1
        self.containerView?.layer.cornerRadius = self.frame.size.width * 0.015
        self.containerView?.layer.shadowRadius = 3;
        self.containerView?.layer.shadowOpacity = 0;
        self.containerView?.layer.shadowOffset = CGSize(width: 1, height: 1)
        
    }
    
    private func setupUI() {
        
        title?.font = UIFont(name: "Avenir-Medium", size: 15)
        summary?.font = UIFont(name: "Avenir-Book", size: 14)
        
        summary?.font = summary?.font.withSize(14)
        setUpConstraint()
        summary?.numberOfLines = 3
        bottomView?.backgroundColor = Constants.Color.CellBottomColor
        readMoreButton?.setTitle("Read More", for: .normal)
        readMoreButton?.backgroundColor = Constants.Color.ButtonColor
        title?.textAlignment = .center
        readMoreButton?.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 15)
    }
    
    private func setUpConstraint() {
        guard let containerView = self.containerView,
            let title = self.title, let summary = self.summary,
            let posterImageView = self.posterImageView,
            let bottomView = self.bottomView,
            let readMoreButton = self.readMoreButton else {
                return
        }
        contentView.addSubview(containerView)
        containerView.addSubview(title)
        containerView.addSubview(summary)
        containerView.addSubview(posterImageView)
        
        
        containerView.addSubview(bottomView)
        bottomView.addSubview(readMoreButton)
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        containerView.addSubview(lineView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        summary.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        readMoreButton.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.constrainToSuperview(5, trailing: -20, bottom: -5, leading: 20)
        
        title.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5).isActive = true
    
        
        title.constrainToView(containerView, top: nil, trailing: 0, bottom: nil, leading: 0)
        
        lineView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5).isActive = true
        lineView.constrainToView(containerView, top: nil, trailing: 0, bottom: nil, leading: 0)
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        posterImageView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 0).isActive = true
        posterImageView.constrainToView(containerView, top: nil, trailing: -10, bottom: nil, leading: 10)
        posterImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        summary.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 5).isActive = true
        summary.constrainToView(containerView, top: nil, trailing: -10, bottom: nil, leading: 10)
        
        bottomView.topAnchor.constraint(equalTo: summary.bottomAnchor, constant: 5).isActive = true
        bottomView.constrainToView(containerView, top: nil, trailing: 0, bottom: 0, leading: 0)
        
        readMoreButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        readMoreButton.constrainToView(bottomView, top: 10, trailing: -10, bottom: -10, leading: 10)
    }
    
    
}
