//
//  ItemDetailVC.swift
//  jtv
//
//  Created by Johnson Ejezie on 02/01/2017.
//  Copyright © 2017 johnsonejezie. All rights reserved.
//

import UIKit

class ItemDetailVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var type:ContentType = .Show
    var movie:Movie?
    var show:Show?
    var similarMovies = [Movie]()
    var recommendedMovies = [Movie]()
    var similarShows = [Show]()
    var recommendedShows = [Show]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch type {
        case .Show:
            self.getDetails(true)
            break
        case .Movie:
            self.getDetails(false)
        }
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ItemDetailVC.cancel(_:)))
        self.navigationItem.rightBarButtonItem = cancel
    }
    
    @objc private func cancel(_ sender:Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func createURL(_ category:String)->URL? {
        let urlString = Constants.APIURL.BaseURL.replacingOccurrences(of: "{type/category}", with: category).replacingOccurrences(of: "[other params]", with: "&language=en-US")
        return URL(string: urlString)
    }
    
    private func getDetails(_ isShow:Bool) {
        if isShow {
            guard let url = createURL("tv/\(self.show!.id)") else {
                return
            }
            Webservice().load(resource: Show.showDetail(url), completion: { result in
                DispatchQueue.main.async {
                    self.show = result
                    self.title = self.show?.name
                    self.tableView.reloadData()
                    
                    DispatchQueue.global(qos: .background).async {
                        self.getShows("tv/\(self.show!.id)/similar", callback: { (shows) in
                            DispatchQueue.main.async {
                                self.similarShows = shows ?? [Show]()
                                self.tableView.reloadData()
                            }
                        })
                        self.getShows("tv/\(self.show!.id)/recommendations", callback: { (shows) in
                            DispatchQueue.main.async {
                                self.recommendedShows = shows ?? [Show]()
                                self.tableView.reloadData()
                            }
                        })
                    }
                }
            })
        }else {
            guard let url = createURL("movie/\(self.movie!.id)") else {
                return
            }
            Webservice().load(resource: Movie.movieDetail(url: url), completion: { result in
                DispatchQueue.main.async {
                    self.movie = result
                    self.title = self.movie?.name
                    
                    DispatchQueue.global(qos: .background).async {
                        self.getSimilarMovies("movie/\(self.movie!.id)/similar", callback: { (movies) in
                            DispatchQueue.main.async {
                                self.similarMovies = movies ?? [Movie]()
                                self.tableView.reloadData()
                            }
                        })
                        
                        self.getSimilarMovies("movie/\(self.movie!.id)/recommendations", callback: { (movies) in
                            DispatchQueue.main.async {
                                self.recommendedMovies = movies ?? [Movie]()
                                self.tableView.reloadData()
                            }
                        })
                    }
                    
                    self.tableView.reloadData()
                }
                
            })
        }
    }
    
    private func getSimilarMovies(_ urlString:String, callback:@escaping (([Movie]?)->())) {
        guard let url = createURL(urlString) else {
            return
        }
        Webservice().load(resource: Movie.getMovies(url: url), completion: {result in
                callback(result)
        })
    }
    
    private func getShows(_ urlString:String, callback:@escaping (([Show]?)->())) {
        guard let url = createURL(urlString) else {
            return
        }
        Webservice().load(resource: Show.getShows(url: url), completion: {result in
            DispatchQueue.main.async {
                callback(result)
            }
        })
    }
}

extension ItemDetailVC:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.movie != nil || self.show != nil {
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 || indexPath.section == 2 {
            guard let tableViewCell = cell as? CollectionViewTableViewCell else {
                return
            }
            if indexPath.section == 1 {
                if !self.similarShows.isEmpty || !self.similarMovies.isEmpty{
                    tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
                }
            }
            if indexPath.section == 2 {
                if !self.recommendedMovies.isEmpty || !self.recommendedShows.isEmpty {
                   tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
                }
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
           let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailTableViewCell") as! ItemDetailTableViewCell
            switch type {
            case .Movie:
                cell.movie = self.movie!
                cell.castTapped = { (id) in
                    let castVC = CastVC(id: id, contentType: .Movie)
                    self.navigationController?.pushViewController(castVC, animated: true)
                }
                cell.reviewTapped = { id in
                    let reviewTVC = ReviewTVC(id, contentType: .Movie)
                    self.navigationController?.pushViewController(reviewTVC, animated: true)
                }
            case .Show:
                cell.show = self.show!
                cell.castTapped = { (id) in
                    let castVC = CastVC(id: id, contentType: .Show)
                    self.navigationController?.pushViewController(castVC, animated: true)
                }
                cell.reviewTapped = { id in
                    let reviewTVC = ReviewTVC(id, contentType: .Show)
                    self.navigationController?.pushViewController(reviewTVC, animated: true)
                }
                cell.seasonTapped = { aShow in
                    let seasonVC = SeasonTVC(aShow)
                    self.navigationController?.pushViewController(seasonVC, animated: true)
                }
            }
            return cell
        }
        
        if indexPath.section == 1 || indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionViewTableViewCell") as! CollectionViewTableViewCell
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return self.type == .Show ? "Similar TV Shows" : "Similar Movies"
        }
        if section == 2 {
            return "Recommendations"
        }
        return nil
    }
}

extension ItemDetailVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        }
        return 150
    }
}

extension ItemDetailVC:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.type {
        case .Movie:
            if collectionView.tag == 1{
                return self.similarMovies.count
            }
            if collectionView.tag == 2 {
                return self.recommendedMovies.count
            }
        case .Show:
            if collectionView.tag == 1{
                return self.similarShows.count
            }
            if collectionView.tag == 2 {
                return self.recommendedShows.count
            }
      
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        switch self.type {
        case .Movie:
            if collectionView.tag == 1{
                cell.movie = self.similarMovies[indexPath.row]
            }
            if collectionView.tag == 2 {
                cell.movie = self.recommendedMovies[indexPath.row]
            }
        case .Show:
            if collectionView.tag == 1{
                cell.show = self.similarShows[indexPath.row]
            }
            if collectionView.tag == 2 {
                cell.show = self.recommendedShows[indexPath.row]
            }
        }
        
        
        return cell
    }
}

extension ItemDetailVC:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "MoviesDetail", bundle: nil).instantiateViewController(withIdentifier: "ItemDetailVC") as! ItemDetailVC
        
        switch self.type {
        case .Movie:
            var movie:Movie?
            if collectionView.tag == 1{
                movie = self.similarMovies[indexPath.row]
                detailVC.movie = movie
            }
            if collectionView.tag == 2 {
                movie = self.recommendedMovies[indexPath.row]
                detailVC.movie = movie
            }
            detailVC.type = .Movie
        case .Show:
            var show:Show?
            if collectionView.tag == 1{
                show = self.similarShows[indexPath.row]
            }
            if collectionView.tag == 2 {
                show = self.recommendedShows[indexPath.row]
            }
            detailVC.show = show
        }
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
