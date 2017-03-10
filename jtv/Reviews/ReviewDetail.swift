//
//  ReviewDetail.swift
//  jtv
//
//  Created by Johnson Ejezie on 12/02/2017.
//  Copyright © 2017 johnsonejezie. All rights reserved.
//

import UIKit

class ReviewDetail: UIViewController {
    
    let review:Review
    
    init(_ review:Review) {
        self.review = review
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Review"
        self.automaticallyAdjustsScrollViewInsets = false
        let authorlabel:UILabel = {
            $0.font =  UIFont(name: "Avenir-Medium", size: 14)
            $0.text = " " + review.author
            $0.backgroundColor = UIColor.white
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: view.topAnchor, constant:64).isActive = true
            $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            return $0
        }(UILabel())
        let _:UITextView = {
            $0.font =  UIFont(name: "Avenir-Medium", size: 14)
            $0.text = review.content
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: authorlabel.bottomAnchor, constant:0).isActive = true
            $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            return $0
        }(UITextView())
    }
    
}
