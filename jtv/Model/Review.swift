//
//  Review.swift
//  jtv
//
//  Created by Johnson Ejezie on 12/02/2017.
//  Copyright © 2017 johnsonejezie. All rights reserved.
//

import Foundation

struct Review {
    let id:String
    let author:String
    let content:String
}

extension Review {
    
    static func getReviews(_ url:URL)->Resource<[Review]> {
        let anyReviews = Resource<[Review]>(url: url, parseJSON: {json in
            guard let dict = json as? JSONDictionary else { return nil }
            guard let dictionaries = dict["results"] as? [JSONDictionary] else { return nil }
            var reviews = [Review]()
            
            for reviewJson in dictionaries {
                let review = Review(json: reviewJson)
                if review != nil {
                    reviews.append(review!)
                }
            }
            return reviews
        })
        return anyReviews
    }
    
}


extension Review {
    init?(json:JSONDictionary) {
        
        guard let id = json["id"] as? String else  { return nil }
        
        let author = json["author"] as? String
        let content = json["content"] as? String
        
        self.id = id
        self.author = author ?? ""
        self.content = content ?? ""
        
    }
}
