//
//  PhotoInfo.swift
//  VirtualTourist
//
//  Created by Min Thet Maung on 22/05/2021.
//

import UIKit

struct PhotoInfo: Codable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let isPublic: Int
    let isFriend: Int
    let isFamily: Int
    
    enum CodingKeys: String, CodingKey {
        case id, owner, secret, server, farm, title
        case isPublic = "ispublic", isFriend = "isfriend", isFamily = "isfamily"
    }
}

struct PageMetadata: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [PhotoInfo]
}

struct PhotosInfoResponse: Codable {
    let photos: PageMetadata
    let stat: String
}

struct PhotoData: Codable {
    let info: PhotoInfo
    var imageData: Data
}
