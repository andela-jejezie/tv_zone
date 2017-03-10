//
//  NavWithSegmentControl.swift
//  jtv
//
//  Created by Johnson Ejezie on 23/12/2016.
//  Copyright © 2016 johnsonejezie. All rights reserved.
//

import UIKit

class NavWithSegmentControl: UINavigationController {
    
    var items = [String]()
    var type:ContentType = .Show
    var segmentControl:UISegmentedControl?
    
    init(_ segmentControlItems:[String]?, tableVC:GenericTVC<Item>) {
        super.init(rootViewController: tableVC)
        if let items = segmentControlItems {
           self.items = items
            segmentControl = UISegmentedControl(items: items)
            setUpCustomUI()
        }
        
        self.navigationItem.title = title
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setUpCustomUI() {
        let navBarView = UIView()
        navBarView.backgroundColor = UIColor.clear
        
        segmentControl?.selectedSegmentIndex = 0
        segmentControl?.addTarget(self, action: #selector(NavWithSegmentControl.segmentControlValueChanged(_:)), for: .valueChanged)
        
        navigationBar.addSubview(navBarView)
        navBarView.addSubview(segmentControl!)
        
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        segmentControl?.translatesAutoresizingMaskIntoConstraints = false
        
        navBarView.constrain(toMarginOf: navigationBar)
        
        segmentControl?.centerXAnchor.constraint(equalTo: navBarView.centerXAnchor).isActive = true
        segmentControl?.centerYAnchor.constraint(equalTo: navBarView.centerYAnchor).isActive = true
        
    }
    
    func segmentControlValueChanged(_ sender:UISegmentedControl) {
        Helpers.selectedSegmentBlock?(sender.selectedSegmentIndex, self.type)
    }
}
