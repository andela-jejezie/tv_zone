//
//  Constants.swift
//  jtv
//
//  Created by Johnson Ejezie on 12/12/2016.
//  Copyright © 2016 johnsonejezie. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct ApiKey {
        static let ClientID = "595939ce6b48d251bd5110fd53205a9b"
        static let ClientSecret = "bb5a2c17ae3a23daed5ce062e1c5b06085d177fde7ff44dabc8ceace48c605db"
        static let APIVersion = "2"
    }
    
    struct APIURL {
        static let BaseURL = "https://api.themoviedb.org/3/{type/category}?api_key=595939ce6b48d251bd5110fd53205a9b[other params]"
        static let Showz = "tv/"
        static let TopRated = "tv/top_rated"
        static let AiringToday = "tv/airing_today"
        static let Popular = "tv/popular"
        static let Latest = "tv/latest"
        static let ImageURL = "http://image.tmdb.org/t/p/w500"
        static let SimilarMovies = "movie/{movie_id}/similar"
        
        static let PopularMovie = "movie/popular"
        static let UpcomingMovie = "movie/upcoming"
        static let TopRatedMovie = "movie/top_rated"
        
        static let mapShowSegmentIndexToURL:[String:String] = [
            "2":AiringToday,
            "0":TopRated,
            "1":Popular,
        ]
        static let mapMovieSegmentIndexToURL:[String:String] = [
            "2":UpcomingMovie,
            "0":TopRatedMovie,
            "1":PopularMovie,
            
        ]
    }
    
    struct Color {
        static let CellBottomColor = UIColor(red: 251/255.0, green: 250/255.0, blue: 248/255.0, alpha: 1)
        static let ButtonColor = UIColor(red: 1.0, green: 0.0, blue: 127/255.0, alpha: 1)
    }
    
    
}
