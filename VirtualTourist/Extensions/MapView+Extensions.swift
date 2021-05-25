//
//  MapView+Extensions.swift
//  VirtualTourist
//
//  Created by Min Thet Maung on 25/05/2021.
//

import MapKit
import UIKit

extension MKMapViewDelegate {
    
    func createPinView(annotation: MKAnnotation, reuseIdentifier: String) -> MKPinAnnotationView {
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        pinView.pinTintColor = .systemBlue
        return pinView
    }
    
    func setupAnnotationView(_ mapView: MKMapView, pinId: String, annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = createPinView(annotation: annotation, reuseIdentifier: pinId)
            return pinView
        }
        
        pinView?.annotation = annotation
        return pinView
    }
    
}

