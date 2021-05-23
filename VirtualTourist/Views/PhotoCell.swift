//
//  PhotoCell.swift
//  VirtualTourist
//
//  Created by Min Thet Maung on 22/05/2021.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: PhotoCell.self)
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setImage(for photoInfo: PhotoInfo) {
        FlickrClient.downloadPhoto(photoInfo: photoInfo) { (data, error) in
            guard let data = data else { return }
            self.imageView.image = UIImage(data: data)
        }
    }
    
    
}
