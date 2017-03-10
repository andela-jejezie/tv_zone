//
//  TabBarController.swift
//  jtv
//
//  Created by Johnson Ejezie on 14/12/2016.
//  Copyright © 2016 johnsonejezie. All rights reserved.
//

import UIKit
import RealmSwift

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var showTab:GenericTVC<Item>?
    var movieTab:GenericTVC<Item>?
    var type:ContentType = .Show
    override func viewDidLoad() {
        super.viewDidLoad()
        Helpers.selectedSegmentBlock = { (index, type) in
            self.type = type
            
            switch type {
            case .Show:
                self.showTab?.items = []
                let code = ShowCategory(rawValue: index)
                if let code = code {
                    self.showTab?.showCategory = code
                    self.showTab?.didSelectSegment(at: index, page: 1)
                }
            case .Movie:
                self.movieTab?.items = []
                self.movieTab?.tableView.reloadData()
                let code = MovieCategory(rawValue: index)
                if let code = code {
                    self.movieTab?.movieCategory = code
                    self.movieTab?
                        
                        
                        .didSelectSegment(at: index, page: 1)
                }
            }
        }
        setupTabs()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.white
        
        
    }
    
    func setupTabs() {
        let realm = try! Realm()
        let shows = realm.objects(Show.self).filter({$0.topRated == true})
        
        
        let items:[Item] = shows.map{.show($0)}
        
        showTab = GenericTVC(items: items, type:.Show, cellDescriptor: {
            $0.cellDescriptor
        })
        showTab?.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        let nc = NavWithSegmentControl(["Top Rated", "Popular", "Airing Today"], tableVC: showTab!)
        nc.type = .Show
        
        let movies = realm.objects(Movie.self).filter({$0.topRated == true })
        let movieItem: [Item] = movies.map{.movie($0)}
        movieTab = GenericTVC(items: movieItem, type:.Movie, cellDescriptor: {
            $0.cellDescriptor
        })
        movieTab?.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
        let nc1 = NavWithSegmentControl(["Top Rated", "Popular", "Upcoming"], tableVC: movieTab!)
        nc1.type = .Movie
        
        let searchVC = SearchVC()
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 2)
        let nc2 = UINavigationController(rootViewController: searchVC)
        
        
        self.viewControllers = [nc1, nc, nc2]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
    
}
