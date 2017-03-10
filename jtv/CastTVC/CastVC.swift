//
//  CastVC.swift
//  jtv
//
//  Created by Johnson Ejezie on 11/02/2017.
//  Copyright © 2017 johnsonejezie. All rights reserved.
//

import UIKit
import Kingfisher

class CastVC: UIViewController {
    
    fileprivate let id:String
    fileprivate let type:ContentType
    fileprivate let tvURLString = "tv/{id}/credits"
    fileprivate let movieURLString = "movie/{id}/credits"
    
    fileprivate var credit:Credit?
    fileprivate var tableView:UITableView?
    init(id:String, contentType:ContentType) {
        self.id = id
        self.type = contentType
       super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(CastTableViewCell.self, forCellReuseIdentifier: "CreditCell")
        self.view.addSubview(tableView!)
        getCast()
    }
    
    private func createURL(_ category:String)->URL? {
        let urlString = Constants.APIURL.BaseURL.replacingOccurrences(of: "{type/category}", with: category).replacingOccurrences(of: "[other params]", with: "&language=en-US")
        
        return URL(string: urlString)
    }
    
    fileprivate func getCast() {
        let urlString = self.type == .Movie ? movieURLString : tvURLString
        guard let url = createURL(urlString.replacingOccurrences(of: "{id}", with: self.id)) else {
            return
        }
        Webservice().load(resource: Credit.getCredit(url: url), completion: { result in
            DispatchQueue.main.async {
                self.credit = result
                self.tableView?.reloadData()
            }
        
        })
    }
    
}

extension CastVC:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let _ = self.credit else {
            return 0
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let credit = self.credit else {
            return 0
        }
        if section == 0 {
            return credit.cast.count
        }else {
            return credit.crew.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let credit = self.credit else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreditCell") as! CastTableViewCell
        if indexPath.section == 0 {
            let cast = credit.cast[indexPath.row]
            cell.cast = cast
            
        }
        if indexPath.section == 1 {
            let crew = credit.crew[indexPath.row]
            cell.crew = crew
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Cast"
        }else {
            return "Crew"
        }
    }
}
