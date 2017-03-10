//
//  ReviewTVC.swift
//  jtv
//
//  Created by Johnson Ejezie on 12/02/2017.
//  Copyright © 2017 johnsonejezie. All rights reserved.
//

import UIKit

class ReviewTVC: UIViewController {
    let id:String
    let type:ContentType
    let movieReviewURL = "movie/{id}/reviews"
    let tvReviewURL = "tv/{id}/reviews"
    
    var reviews = [Review]()
    var tableView:UITableView?
    init(_ id:String, contentType:ContentType) {
        self.id = id
        self.type = contentType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reviews"
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
        getReviews()
    }
    
    private func createURL(_ category:String)->URL? {
        let urlString = Constants.APIURL.BaseURL.replacingOccurrences(of: "{type/category}", with: category).replacingOccurrences(of: "[other params]", with: "&language=en-US")
        
        return URL(string: urlString)
    }
    
    private func getReviews() {
        let urlString = self.type == .Movie ? movieReviewURL : tvReviewURL
        guard let url = createURL(urlString.replacingOccurrences(of: "{id}", with: self.id)) else {
            return
        }
        Webservice().load(resource: Review.getReviews(url), completion: { result in
            DispatchQueue.main.async {
                self.reviews = result ?? [Review]()
                self.tableView?.reloadData()
            }
        })
    }
    
}

extension ReviewTVC:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ReviewCell")
            cell?.selectionStyle = .none
            cell?.accessoryType = .detailButton
            
        }
        let review = reviews[indexPath.row]
        cell?.textLabel?.text = review.author
        cell?.detailTextLabel?.text = review.content
        return cell!
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let review = self.reviews[indexPath.row];
        let reviewDetail = ReviewDetail(review)
        self.navigationController?.pushViewController(reviewDetail, animated: true)
    }
    
}
