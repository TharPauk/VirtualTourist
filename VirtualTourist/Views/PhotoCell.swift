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
    
    func downloadPhoto(for photoInfo: PhotoInfo, pin: Pin) {
        FlickrClient.downloadPhoto(photoInfo: photoInfo) { (data, error) in
            guard let data = data else { return }
            
            self.savePhoto(pin: pin, photoData: data)
            
        }
    }
    
    
    private func savePhoto(pin: Pin, photoData: Data) {
        guard let backgroundContext = dataController.backgroundContext else { return }
        let pinFromBackgroundContext = backgroundContext.object(with: pin.objectID) as! Pin
        
        dataController.backgroundContext.perform {
            let photo = Photo(context: backgroundContext)
            photo.pin = pinFromBackgroundContext
            photo.data = photoData
            try? backgroundContext.save()
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: photoData)
            }
        }
    }

    
    
}
