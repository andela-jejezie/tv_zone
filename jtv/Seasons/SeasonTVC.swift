//
//  SeasonTVC.swift
//  jtv
//
//  Created by Johnson Ejezie on 12/02/2017.
//  Copyright © 2017 johnsonejezie. All rights reserved.
//

import UIKit

class SeasonTVC : UITableViewController {
    
    
    let show:Show
    
    init(_ show:Show) {
        self.show = show
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Seasons"
        tableView.register(SeasonTableViewCell.self, forCellReuseIdentifier: "SeasonTableViewCell")
    }
}

extension SeasonTVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return show.seasons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeasonTableViewCell") as! SeasonTableViewCell
        cell.season = self.show.seasons[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
