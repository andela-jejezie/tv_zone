//
//  Movie.swift
//  jtv
//
//  Created by Johnson Ejezie on 01/01/2017.
//  Copyright © 2017 johnsonejezie. All rights reserved.
//

import Foundation

import RealmSwift
import Realm

class Movie: Object {
    
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
    dynamic var revenue = 0
    dynamic var budget = 0
    dynamic var productionCompanies = ""
    dynamic var productionCountries = ""
    dynamic var spokenLanguages = ""
    dynamic var genres = ""
    
    dynamic var popular = false
    dynamic var topRated = false
    dynamic var latest = false
    dynamic var upcoming = false
    
    dynamic var latestPage = 0
    dynamic var upcomingPage = 0
    dynamic var popularPage = 0
    dynamic var topRatedPage = 0
    
    dynamic var latestTotalPage = 0
    dynamic var upcomingTotalPage = 0
    dynamic var popularTotalPage = 0
    dynamic var topRatedTotalPage = 0
    //    var episodes = List<Episode>()
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    
}


extension Movie {
    func configureCell( _ cell:ItemCell) {
        cell.movie = self
    }
}


extension Movie {
    
    static func getMovies(url:URL)-> Resource<[Movie]> {
        let anyMovies = Resource<[Movie]>(url: url, parseJSON: {json in
            guard let dict = json as? JSONDictionary else { return nil }
            guard let dictionaries = dict["results"] as? [JSONDictionary] else { return nil }
            var movies = [Movie]()
                for movie in dictionaries {
                    let aMovie = Movie(dictionary:movie, category:nil, page:nil, totalPage:nil)
                    movies.append(aMovie)
                }

            return movies
        })
        return anyMovies
    }
    
    static func movieDetail(url:URL) -> Resource<Movie> {
        let aMovie = Resource<Movie>(url: url, parseJSON: {json in
            guard let dict = json as? JSONDictionary else { return nil }
            
            let movieDetail = Movie(dictionary:dict, category:nil, page:nil, totalPage:nil)
            return movieDetail
            
        })
        return aMovie
    }

    static func topRated(url:URL)->Resource<[Movie]> {
        let topRated = Resource<[Movie]>(url: url, parseJSON: {json in
            guard let dict = json as? JSONDictionary else { return nil }
            let page = dict["page"] as! Int
            let totalPage = dict["total_pages"] as! Int
            guard let dictionaries = dict["results"] as? [JSONDictionary] else { return nil }
            var movies = [Movie]()
            let realm = try! Realm()
            
            try! realm.write {
                for movie in dictionaries {
                    let aMovie = Movie(dictionary:movie, category:.TopRated, page:page, totalPage:totalPage)
                    realm.add(aMovie, update:true)
                    movies.append(aMovie)
                }
            }
            return movies
        })
        return topRated
    }
    
    static func upcoming(url:URL)->Resource<[Movie]> {
        let upcoming = Resource<[Movie]>(url: url, parseJSON: {json in
            print(json)
            guard let dict = json as? JSONDictionary else { return nil }
            let page = dict["page"] as! Int
            let totalPage = dict["total_pages"] as! Int
            guard let dictionaries = dict["results"] as? [JSONDictionary] else { return nil }
            var movies = [Movie]()
            for movie in dictionaries {
                let aMovie = Movie(dictionary:movie, category:.Upcoming, page:page, totalPage:totalPage)
                movies.append(aMovie)
                
            }
            return movies
        })
        return upcoming
    }
    
    static func popular(url:URL)->Resource<[Movie]> {
        let popular = Resource<[Movie]>(url: url, parseJSON: {json in
            guard let dict = json as? JSONDictionary else { return nil }
            let page = dict["page"] as! Int
            let totalPage = dict["total_pages"] as! Int
            guard let dictionaries = dict["results"] as? [JSONDictionary] else { return nil }
            var movies = [Movie]()
            let realm = try! Realm()
            
            try! realm.write {
                for movie in dictionaries {
                    let aMovie = Movie(dictionary:movie, category:.Popular, page:page, totalPage:totalPage)
                    realm.add(aMovie, update:true)
                    movies.append(aMovie)
                    
                }
            }
            return movies
        })
        return popular
    }

}

extension Movie {
    
    convenience init(dictionary: JSONDictionary, category:MovieCategory?, page:Int?, totalPage:Int?) {
        self.init()
        if let id = dictionary["id"] as? Int {
            self.id = NSNumber(value: id)
        }
        if let category = category {
            switch category {
            case .Upcoming:
                self.upcoming = true
                self.upcomingPage = page!
                self.upcomingTotalPage = totalPage!
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
        
        if let name = dictionary["original_title"] as? String {  self.name = name }
        
        if let voteCount = dictionary["vote_count"] as? Int {
            self.voteCount = voteCount
        }
        
        if let voteAverage = dictionary["vote_average"] as? Double {
            self.voteAverage = voteAverage
        }
        if let overview = dictionary["overview"] as? String {
            self.overview = overview
        }
        
        if let premiered = dictionary["release_date"] as? String {
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
        
        if let status = dictionary["status"] as? String {
            self.status = status
        }
        
        if let runtime = dictionary["runtime"] as? Int {
            self.runtime = runtime
        }
        
        if let revenue = dictionary["revenue"] as? Int {
            self.revenue = revenue
        }
        
        if let budget = dictionary["budget"] as? Int {
            self.budget = budget
        }
        
        if let genres = dictionary["genres"] as? [JSONDictionary] {
            var names = [String]()
            for json in genres {
                if let name = json["name"] as? String {
                    names.append(name)
                }
            }
            self.genres = names.joined(separator: ",")
        }
        if let spokenLanguages = dictionary["spoken_languages"] as? [JSONDictionary] {
            var names = [String]()
            for json in spokenLanguages {
                if let name = json["name"] as? String {
                    names.append(name)
                }
            }
            self.spokenLanguages = names.joined(separator: ",")
        }
        
        if let productionCompanies = dictionary["production_companies"] as? [JSONDictionary] {
            var names = [String]()
            for json in productionCompanies {
                if let name = json["name"] as? String {
                    names.append(name)
                }
            }
            self.productionCompanies = names.joined(separator: ",")
        }
        
        if let productionCountries = dictionary["production_countries"] as? [JSONDictionary] {
            var names = [String]()
            for json in productionCountries {
                if let name = json["name"] as? String {
                    names.append(name)
                }
            }
            self.productionCountries = names.joined(separator: ",")
        }
    }
}
