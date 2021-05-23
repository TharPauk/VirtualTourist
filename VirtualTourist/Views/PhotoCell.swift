//
//  PhotoCell.swift
//  VirtualTourist
//
//  Created by Min Thet Maung on 22/05/2021.
//

import UIKit
import CoreData

class PhotoCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: PhotoCell.self)
    
    @IBOutlet weak var imageView: UIImageView!
    var dataController: DataController!
    
    func setData(for photoInfo: PhotoInfo, pin: Pin) {
        FlickrClient.downloadPhoto(photoInfo: photoInfo) { (data, error) in
            guard let data = data else { return }
            self.dataController.backgroundContext.perform {
                let photo = Photo(context: self.dataController.backgroundContext)
                photo.pin = pin
                photo.data = data
                try? self.dataController.backgroundContext.save()
            }
            self.imageView.image = UIImage(data: data)
        }
    }
    
    
}
