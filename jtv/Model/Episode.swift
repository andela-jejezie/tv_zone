//
//  Episode.swift
//  jtv
//
//  Created by Johnson Ejezie on 12/12/2016.
//  Copyright © 2016 johnsonejezie. All rights reserved.
//

import Foundation

import RealmSwift

class Episode: Object {
    dynamic var id:NSNumber = 0
    dynamic var name = ""
    dynamic var season = 0
    dynamic var number = 0
    dynamic var airdate = Date()
    dynamic var summary = ""
    dynamic var imageURL = ""
    dynamic var voteAverage = 0.0
    
}

extension Episode {
    convenience init?(_ json:JSONDictionary) {
       self.init()
        guard let id = json["id"] as? NSNumber else {
            return nil
        }
        let episodeNumber = json["episode_number"] as? Int
        
        let name = json["name"] as? String
        let overview = json["overview"] as? String
        let averageVote = json["vote_average"] as? Double
        let season = json["season_number"] as? Int
        let imageURL = json["still_path"] as? String
        let airdate = json["air_date"] as? String
        
        self.id = id
        self.number = episodeNumber ?? 0
        self.season = season ?? 0
        self.summary = overview ?? ""
        self.name = name ?? ""
        self.voteAverage = averageVote ?? 0
        
        if let premiered = airdate {
            if let date = Helpers.convertToDate(jsonString: premiered) {
                self.airdate = date
            }
        }
        if let image = imageURL {
            self.imageURL = Constants.APIURL.ImageURL + image
        }
        
    }
}

