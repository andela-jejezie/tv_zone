//
//  SearchVC.swift
//  jtv
//
//  Created by Johnson Ejezie on 10/02/2017.
//  Copyright © 2017 johnsonejezie. All rights reserved.
//

import UIKit

class SearchVC:UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSearch()
        self.configureSegmentControl()
        self.configureTableView()
        
    }
    fileprivate var shows = [Show]()
    fileprivate var movies = [Movie]()
    fileprivate var urlString = "search/movie"
    fileprivate var contentType = ContentType.Movie
    var searchController:UISearchController? = nil
    var segmentControl:UISegmentedControl? = nil
    var tableView:UITableView? = nil
    
    //MARK: - Configure search
    fileprivate func configureSearch() {
        self.searchController = UISearchController(searchResultsController: nil)
        if let _searchController = self.searchController {
            _searchController.delegate = self
            _searchController.hidesNavigationBarDuringPresentation = false
            _searchController.dimsBackgroundDuringPresentation = false
            _searchController.searchBar.delegate = self
            _searchController.searchBar.sizeToFit()
            _searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
            self.definesPresentationContext = true
            navigationItem.titleView = searchController?.searchBar
        }else {
            print("error configuring _searchcontroller in %@", #function)
        }
    }
    
    fileprivate func configureSegmentControl() {
        self.segmentControl = UISegmentedControl(items: ["Movie", "TV Series"])
        self.segmentControl?.addTarget(self, action: #selector(SearchVC.segmentControlValueChanged(_:)), for: .valueChanged)
        self.segmentControl?.selectedSegmentIndex = 0
        self.view.addSubview(segmentControl!)
    }
    
    fileprivate func configureTableView() {
        self.tableView = UITableView()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(tableView!)
        self.tableView?.tableFooterView = UIView(frame: CGRect.zero)
        tableView?.register(ItemCell.self, forCellReuseIdentifier: "ItemCell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let tableView = self.tableView, let segmentControl = self.segmentControl else {
            return
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentControl.topAnchor.constraint(equalTo: (self.navigationController?.navigationBar.bottomAnchor)!, constant:8).isActive = true
        segmentControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant:8).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func segmentControlValueChanged(_ sender:UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.contentType = .Movie
        }else {
            self.contentType = .Show
        }
    }
    
    private func createURL(_ category:String, query:String)->URL? {
        let urlString = Constants.APIURL.BaseURL.replacingOccurrences(of: "{type/category}", with: category).replacingOccurrences(of: "[other params]", with: "&language=en-US&query=\(query)")
        
        return URL(string: urlString)
    }
    
    fileprivate func performSearch(_ searchText:String) {
        guard let url = createURL(self.urlString, query: searchText) else {
            return
        }
        Webservice().load(resource: Movie.getMovies(url: url), completion: {result in
            DispatchQueue.main.async {
                self.movies = result ?? [Movie]()
                self.tableView?.reloadData()
            }
        })
    }
}

extension SearchVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch contentType {
        case .Movie:
            return movies.count
        case .Show:
            return shows.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
        cell.movie = self.movies[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
}

extension SearchVC:UISearchBarDelegate, UISearchControllerDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        self.performSearch(searchText.replacingOccurrences(of: " ", with: "%20"))
    }
}
