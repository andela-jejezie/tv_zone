//
//  CellDescriptor.swift
//  jtv
//
//  Created by Johnson Ejezie on 12/12/2016.
//  Copyright © 2016 johnsonejezie. All rights reserved.
//

import UIKit

struct CellDescriptor {
    let cellClass: UITableViewCell.Type
    let reuseIdentifier: String
    let configure: (UITableViewCell) -> ()
    
    init<Cell: UITableViewCell>(reuseIdentifier: String, configure: @escaping (Cell) -> ()) {
        self.cellClass = Cell.self
        self.reuseIdentifier = reuseIdentifier
        self.configure = { cell in
            configure(cell as! Cell)
        }
    }
}

enum Item {
    case show(Show)
    case movie(Movie)
}

extension Item {
    var cellDescriptor: CellDescriptor  {
        switch self {
        case .show(let show):
            return CellDescriptor(reuseIdentifier: "ItemCell", configure: show.configureCell)
        case .movie(let movie):
            return CellDescriptor(reuseIdentifier: "ItemCell", configure: movie.configureCell)
        }
    }
}
