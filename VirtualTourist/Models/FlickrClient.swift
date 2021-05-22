//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Min Thet Maung on 22/05/2021.
//

import Foundation

class FlickrClient {
    
    static let apiKey = "f655eec278a3a12643ed5c7eab26f060"
    
    enum EndPoints {
        static let apiUrl = "https://www.flickr.com/services/rest"
        static let imageUrl = "https://live.staticflickr.com"
        
        static let methodParam = "/?method=flickr.photos.search"
        static let apiKeyParam = "&api_key=\(FlickrClient.apiKey)"
        static let formatParam = "&per_page=16&format=json&nojsoncallback=1"
        
        case search(Double, Double)
        case downloadImage(String, String, String)
        
        var stringValue: String {
            switch self {
            case .search(let lat, let lon):
                return EndPoints.apiUrl + EndPoints.methodParam + EndPoints.apiKeyParam + EndPoints.formatParam + "&lat=\(lat)&lon=\(lon)"
            case .downloadImage(let server, let id, let secret):
                return "\(EndPoints.imageUrl)/\(server)/\(id)_\(secret)_q.jpg"
            }
        }
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
    }
    
    
}
