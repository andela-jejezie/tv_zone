//
//  Show.swift
//  jtv
//
//  Created by Johnson Ejezie on 12/12/2016.
//  Copyright © 2016 johnsonejezie. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Show: Object {
    
    dynamic var id:NSNumber = 0
    dynamic var name = ""
    dynamic var voteCount = 0
    dynamic var premiered = Date()
    dynamic var voteAverage = 0.0
    dynamic var overview = ""
    dynamic var imageURL = ""
    dynamic var popularity = 0.0
    
    dynamic var status = ""
    dynamic var runtime = 0
    dynamic var productionCompanies = ""
    dynamic var productionCountries = ""
    dynamic var spokenLanguages = ""
    dynamic var numberOfEpisode = 0
    dynamic var numberOfSeason = 0
    dynamic var genres = ""
    
    dynamic var popular = false
    dynamic var airingToday = false
    dynamic var topRated = false
    
    dynamic var airingTodayPage = 0
    dynamic var popularPage = 0
    dynamic var topRatedPage = 0
    
    dynamic var airingTodayTotalPage = 0
    dynamic var popularTotalPage = 0
    dynamic var topRatedTotalPage = 0
    let seasons = List<Season>()
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    
}

class Season: Object {
    dynamic var id:NSNumber = 0
    dynamic var episodeCount:Int = 0
    dynamic var imageURL:String = ""
    dynamic var seasonNumber:Int = 0
    dynamic var airdate:Date = Date()
    
    override class func primaryKey() -> String {
        return "id"
    }
}

extension Season {
    convenience init(_ json:JSONDictionary) {
        self.init()
        let id = json["id"] as? NSNumber
        let episodeCount = json["episode_count"] as? Int
        let seasonNumber = json["season_number"] as? Int
        if let premiered = json["air_date"] as? String {
            if let date = Helpers.convertToDate(jsonString: premiered) {
                self.airdate = date
            }
        }
        if let image = json["poster_path"] as? String {
            self.imageURL = Constants.APIURL.ImageURL + image
        }
        self.id = id ?? 0
        self.seasonNumber = seasonNumber ?? 0
        self.episodeCount = episodeCount ?? 0
    }
}




extension Show {
    func configureCell( _ cell:ItemCell) {
        cell.show = self
    }
}


extension Show {
    
    static func getShows(url:URL)-> Resource<[Show]> {
        let anyShows = Resource<[Show]>(url: url, parseJSON: {json in
            guard let dict = json as? JSONDictionary else { return nil }
            guard let dictionaries = dict["results"] as? [JSONDictionary] else { return nil }
            var shows = [Show]()
            for show in dictionaries {
                let aShow = Show(dictionary:show, category:nil, page:nil, totalPage:nil)
                shows.append(aShow)
            }
            
            return shows
        })
        return anyShows
    }
    
    static func showDetail(_ url:URL)->Resource<Show> {
        let show = Resource<Show>(url: url, parseJSON: { json in
            guard let dict = json as? JSONDictionary else { return nil }
            print(dict)
            let showDetail = Show(dictionary:dict, category:nil, page:nil, totalPage:nil)
            return showDetail
        })
        return show
    }
    static func topRated(url:URL)->Resource<[Show]> {
        let topRatedShows = Resource<[Show]>(url: url, parseJSON: {json in
            guard let dict = json as? JSONDictionary else { return nil }
            let page = dict["page"] as! Int
            let totalPage = dict["total_pages"] as! Int
            guard let dictionaries = dict["results"] as? [JSONDictionary] else { return nil }
            var shows = [Show]()
            let realm = try! Realm()
            
            try! realm.write {
                for show in dictionaries {
                    let aShow = Show(dictionary:show, category:.TopRated, page:page, totalPage:totalPage)
                    realm.add(aShow, update:true)
                    shows.append(aShow)
                }
            }
            return shows
        })
        return topRatedShows
    }
    
    static func airingToday(url:URL)->Resource<[Show]> {
        let airingTodayShows = Resource<[Show]>(url: url, parseJSON: {json in
            guard let dict = json as? JSONDictionary else { return nil }
            let page = dict["page"] as! Int
            let totalPage = dict["total_pages"] as! Int
            guard let dictionaries = dict["results"] as? [JSONDictionary] else { return nil }
            var shows = [Show]()
            for show in dictionaries {
                let aShow = Show(dictionary:show, category:.AiringToday, page:page, totalPage:totalPage)
                shows.append(aShow)
                
            }
            return shows
        })
        return airingTodayShows
    }
    
    static func popular(url:URL)->Resource<[Show]> {
        let popular = Resource<[Show]>(url: url, parseJSON: {json in
            guard let dict = json as? JSONDictionary else { return nil }
            let page = dict["page"] as! Int
            let totalPage = dict["total_pages"] as! Int
            guard let dictionaries = dict["results"] as? [JSONDictionary] else { return nil }
            var shows = [Show]()
            let realm = try! Realm()
            
            try! realm.write {
                for show in dictionaries {
                    let aShow = Show(dictionary:show, category:.Popular, page:page, totalPage:totalPage)
                    realm.add(aShow, update:true)
                    shows.append(aShow)
                    
                }
            }
            return shows
        })
        
        return popular
        
    }
}

extension Show {
    convenience init(dictionary: JSONDictionary, category:ShowCategory?, page:Int?, totalPage:Int?) {
        self.init()
        if let id = dictionary["id"] as? Int {
            self.id = NSNumber(value: id)
        }
        if let category = category {
            switch category {
            case .AiringToday:
                self.airingToday = true
                self.airingTodayPage = page!
                self.airingTodayTotalPage = totalPage!
            case .Popular:
                self.popular = true
                self.popularPage = page!
                self.popularTotalPage = totalPage!
            case .TopRated:
                self.topRated = true
                self.topRatedPage = page!
                self.topRatedTotalPage = page!
                
            }
        }
        
        if let name = dictionary["name"] as? String {  self.name = name }
        
        if let voteCount = dictionary["vote_count"] as? Int {
            self.voteCount = voteCount
        }
        
        if let voteAverage = dictionary["vote_average"] as? Double {
            self.voteAverage = voteAverage
        }
        if let overview = dictionary["overview"] as? String {
            self.overview = overview
        }
        
        if let premiered = dictionary["first_air_date"] as? String {
            if let date = Helpers.convertToDate(jsonString: premiered) {
                self.premiered = date
            }
        }
        
        if let popularity = dictionary["popularity"] as? Double {
            self.popularity = popularity
        }
        
        if let image = dictionary["poster_path"] as? String {
            self.imageURL = Constants.APIURL.ImageURL + image
        }
        
        print(self.imageURL)
        
        if let numberOfSeason = dictionary["number_of_seasons"] as? Int {
            self.numberOfSeason = numberOfSeason
        }
        if let numberOfEpisode = dictionary["number_of_episodes"] as? Int {
            self.numberOfEpisode = numberOfEpisode
        }
        
        if let genres = dictionary["genres"] as? [JSONDictionary] {
            var names = [String]()
            for json in genres {
                if let name = json["name"] as? String {
                    names.append(name)
                }
            }
            self.genres = names.joined(separator: ", ")
        }
        if let genres = dictionary["production_companies"] as? [JSONDictionary] {
            var names = [String]()
            for json in genres {
                if let name = json["name"] as? String {
                    names.append(name)
                }
            }
            self.productionCompanies = names.joined(separator: ", ")
        }
        if let spokenLanguages = dictionary["languages"] as? [JSONDictionary] {
            var names = [String]()
            for json in spokenLanguages {
                if let name = json["name"] as? String {
                    names.append(name)
                }
            }
            self.spokenLanguages = names.joined(separator: ",")
        }
        print(dictionary)
        
        if let countries = dictionary["languages"] as? [String] {
            self.productionCountries = countries.joined(separator: ",")
        }
        if let seasonArray = dictionary["seasons"] as? [JSONDictionary] {
            
            for seasonDict in seasonArray {
                let season = Season(seasonDict)
                self.seasons.append(season)
            }
        }
    }
}


extension Sequence {
    public func failingFlatMap<T>( transform: (Self.Iterator.Element) throws -> T?) rethrows -> [T]? {
        var result: [T] = []
        for element in self {
            guard let transformed = try transform(element) else { return nil }
            result.append(transformed)
        }
        return result
    }
}
