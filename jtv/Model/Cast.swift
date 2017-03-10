//
//  Cast.swift
//  jtv
//
//  Created by Johnson Ejezie on 11/02/2017.
//  Copyright © 2017 johnsonejezie. All rights reserved.
//

import Foundation


struct Credit {
    let cast:[Cast]
    let crew:[Crew]
}

extension Credit {
    static func getCredit(url:URL)-> Resource<Credit> {
        let anyCredits = Resource<Credit>(url: url, parseJSON: {json in
            guard let dict = json as? JSONDictionary else { return nil }
            let castObject = dict["cast"] as? [JSONDictionary]
            var casts = [Cast]()
            if let castObjects =  castObject {
                for castDict in castObjects {
                    let cast = Cast(castDict)
                    casts.append(cast!)
                }
            }
            let crewObject = dict["crew"] as? [JSONDictionary]
            var crews = [Crew]()
            if let crewObjects =  crewObject {
                for crewDict in crewObjects {
                    let crew = Crew(crewDict)
                    crews.append(crew!)
                }
            }
            let credit = Credit(cast: casts, crew: crews)
           
            return credit
        })
        return anyCredits
    }
}

struct Crew {
    
    let id:NSNumber
    let name:String
    let creditID:String
    let imageURL:String
    let department:String
    let job:String

}

extension Crew {
    init?(_ json:JSONDictionary) {
        guard let id = json["id"] as? NSNumber else {
            return nil
        }
        let name = json["name"] as? String
//        let character = json["character"] as? String
        let creditId = json["credit_id"] as? String
        let department = json["department"] as? String
        let job = json["job"] as? String
        let imageURL = json["profile_path"] as? String
        
        self.id = id
        self.name = name ?? ""
        self.creditID = creditId ?? ""
        self.department = department ?? ""
        self.job = job ?? ""
        if let url = imageURL {
            self.imageURL = Constants.APIURL.ImageURL + url
        }else {
            self.imageURL = ""
        }
    }
}

struct Cast {
    let id:NSNumber
    let name:String
    let character:String
    let creditID:String
    let imageURL:String
}

extension Cast {
    init?(_ json:JSONDictionary) {
        guard let id = json["id"] as? NSNumber else {
            return nil
        }
        let name = json["name"] as? String
        let character = json["character"] as? String
        let creditId = json["credit_id"] as? String
        let imageURL = json["profile_path"] as? String
        
        self.id = id
        self.name = name ?? ""
        self.creditID = creditId ?? ""
        self.character = character ?? ""
        if let url = imageURL {
            self.imageURL = Constants.APIURL.ImageURL + url
        }else {
            self.imageURL = ""
        }
    }
}
