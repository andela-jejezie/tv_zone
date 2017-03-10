//
//  Helpers.swift
//  jtv
//
//  Created by Johnson Ejezie on 12/12/2016.
//  Copyright © 2016 johnsonejezie. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

struct Helpers {
    static var selectedSegmentBlock:((Int, ContentType) -> ())?
    static var didSelectShow:((Show)->())?
    static var didSelectMovie:((Movie)->())?
    
    static func downloadAndSetImage(_ urlString:String, imageView:UIImageView, height:CGFloat, width:CGFloat) {
        if let url = URL(string:urlString)  {
            ImageDownloader.default.downloadImage(with: url, options: nil, progressBlock: nil, completionHandler: { (image, error, _, _) in
                if let image = image {
                    imageView.image = image.imageWithImage(scaledToMaxWidth: width, maxHeight: height)
                }
            })
        }
    }
        
    static func convertToDate(jsonString date:String) -> Date? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        return dateformatter.date(from: date)
    }
    
    static func currentFormmatter (_ amount:Int)->String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.locale = Locale.current
        currencyFormatter.alwaysShowsDecimalSeparator = true
        currencyFormatter.numberStyle = .currency
        return currencyFormatter.string(from: NSNumber(value: Float(amount) as Float))!
    }
    
    static func convertDateToString(_ date:Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-YYYY"
        return dateformatter.string(from: date)
    }
    
    static func URLFromString(string:String) -> URL? {
        return URL(string: string)
    }
    
    static func loadShow(for category:ShowCategory, segmentIndex:Int, page:Int, callback:@escaping (Any)->()) {
        var resource:Resource<[Show]>
        guard let url = URL(string: createURL(for: .Show, segmentIndex: segmentIndex, at: page)) else {
            return
        }
        switch category {
        case .AiringToday:
            resource = Show.airingToday(url: url)
        case .Popular:
            resource = Show.popular(url: url)
        case .TopRated:
            resource = Show.topRated(url: url)
        }
        Webservice().load(resource: resource, completion: { results in
            DispatchQueue.main.async {
                let realm = try! Realm()
                var shows:[Show] = []
                switch category {
                case .AiringToday:
                    shows = results!
                case .Popular:
                    shows = realm.objects(Show.self).filter({$0.popular == true})
                case .TopRated:
                    shows = realm.objects(Show.self).filter({$0.topRated == true})
                }
                let items:[Item] = shows.map{.show($0)}
                callback(items)
            }
            
        })
    }
    
    static func loadMovie(for category:MovieCategory, segmentIndex:Int, page:Int, callback:@escaping (Any)->()) {
        var resource:Resource<[Movie]>
        guard let url = URL(string: createURL(for: .Movie, segmentIndex: segmentIndex, at: page)) else {
            return
        }
        switch category {
        case .Popular:
            resource = Movie.popular(url: url)
        case .Upcoming:
            resource = Movie.upcoming(url: url)
        case .TopRated:
            resource = Movie.topRated(url: url)
        }
        Webservice().load(resource: resource, completion: { results in
            DispatchQueue.main.async {
                let realm = try! Realm()
                var movies:[Movie] = []
                switch category {
                case .Upcoming:
                    movies = results!
                case .Popular:
                    movies = realm.objects(Movie.self).filter({$0.popular == true})
                case .TopRated:
                    movies = realm.objects(Movie.self).filter({$0.topRated == true})
                }
                let items:[Item] = movies.map{.movie($0)}
                callback(items)
            }
            
        })
    }
    
    
    static func createURL(for type:ContentType, segmentIndex:Int, at page:Int) -> String {
        var category = ""
        if type == .Show {
            category = Constants.APIURL.mapShowSegmentIndexToURL["\(segmentIndex)"]!
        }else {
            category = Constants.APIURL.mapMovieSegmentIndexToURL["\(segmentIndex)"]!
        }
        return Constants.APIURL.BaseURL.replacingOccurrences(of: "{type/category}", with: category).replacingOccurrences(of: "[other params]", with: "&language=en-US&page=\(page)")
    }
    
    static func resizeImage(image:UIImage, size:CGSize) -> UIImage
    {
        
        var actualHeight:Float = Float(image.size.height)
        var actualWidth:Float = Float(image.size.width)
        
        let maxHeight:Float = Float(size.height)
        let maxWidth:Float = Float(size.width) 
        
        var imgRatio:Float = actualWidth/actualHeight
        let maxRatio:Float = maxWidth/maxHeight
        
        if (actualHeight > maxHeight) || (actualWidth > maxWidth)
        {
            if(imgRatio < maxRatio)
            {
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio)
            {
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else
            {
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        let rect:CGRect = CGRect(x:0.0, y:0.0, width:CGFloat(actualWidth) , height:CGFloat(actualHeight) )
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:NSData = UIImageJPEGRepresentation(img, 1.0)! as NSData
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData as Data)!
    }
    
}
