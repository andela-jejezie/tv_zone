//
//  GenericTVC.swift
//  jtv
//
//  Created by Johnson Ejezie on 12/12/2016.
//  Copyright © 2016 johnsonejezie. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

enum ContentType {
    case Movie
    case Show
}
enum ShowCategory:Int {
    case TopRated = 0
    case Popular = 1
    case AiringToday = 2
}

enum MovieCategory:Int {
    case TopRated = 0
    case Popular = 1
    case Upcoming = 2
}

final class GenericTVC<Item>: UITableViewController {
    var type:ContentType = .Show
    var showCategory:ShowCategory = .TopRated
    var movieCategory:MovieCategory = .TopRated
    var didSelect: (Item) -> () = { _ in }
    var items = [Item]()
    let cellDescriptor: (Item) -> CellDescriptor
    var reuseIdentifiers: Set<String> = []
    
    init(items: [Item], type:ContentType, cellDescriptor: @escaping (Item) -> CellDescriptor) {
        self.cellDescriptor = cellDescriptor
        self.type = type
        super.init(style: .plain)
        self.tableView.separatorStyle = .none
        self.items = items
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        Helpers.didSelectMovie = { movie in
            let detailVC = UIStoryboard(name: "MoviesDetail", bundle: nil).instantiateViewController(withIdentifier: "ItemDetailVC") as! ItemDetailVC
            detailVC.type = .Movie
            detailVC.movie = movie
            let nc = UINavigationController(rootViewController: detailVC)
            self.navigationController?.present(nc, animated: true, completion: nil)
        }
        
        Helpers.didSelectShow = { show in
            let detailVC = UIStoryboard(name: "MoviesDetail", bundle: nil).instantiateViewController(withIdentifier: "ItemDetailVC") as! ItemDetailVC
            detailVC.type = .Show
            detailVC.show = show
            let nc = UINavigationController(rootViewController: detailVC)
            self.navigationController?.present(nc, animated: true, completion: nil)
        }
        
        switch self.type {
        case .Show:
            if self.items.isEmpty {
                self.loadShow(.TopRated, index: 0, page:1)
            }
        case .Movie:
            if self.items.isEmpty {
                self.loadMovie(self.movieCategory, index: 0, page:1)
            }
        }
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let descriptor = cellDescriptor(item)
        
        if !reuseIdentifiers.contains(descriptor.reuseIdentifier) {
            tableView.register(descriptor.cellClass, forCellReuseIdentifier: descriptor.reuseIdentifier)
            reuseIdentifiers.insert(descriptor.reuseIdentifier)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: descriptor.reuseIdentifier, for: indexPath)
        descriptor.configure(cell)
        return cell
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension GenericTVC {
    func didSelectSegment(at index:Int, page:Int) {        
        switch self.type {
        case .Show:
            loadShow(self.showCategory, index: index, page:page)
            break
        case .Movie:
            loadMovie(self.movieCategory, index: index, page:page)
        }
    }
    func loadShow(_ category:ShowCategory, index:Int, page:Int) {
        Helpers.loadShow(for: category, segmentIndex: index, page: page, callback: { moreItems in
            guard let shows = moreItems as? [Item] else  { return }
            self.items = shows
            print(self.items)
            self.tableView.reloadData()
            
        })
    }
    func loadMovie(_ category:MovieCategory, index:Int, page:Int) {
        Helpers.loadMovie(for: category, segmentIndex: index, page: page, callback: { moreMovies in
            guard let movies = moreMovies as? [Item] else { return }
            self.items.removeAll()
            self.items = movies
            print(self.items)
            self.tableView.reloadData()
        })
    }
}

