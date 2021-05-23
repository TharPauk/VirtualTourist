//
//  TravelLocationsMapViewController.swift
//  VirtualTourist
//
//  Created by Min Thet Maung on 19/05/2021.
//

import UIKit
import MapKit

class TravelLocationsMapViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var mapView: MKMapView!
    var longGestureRecognizer: UILongPressGestureRecognizer!
    private var selectedLocation: CLLocation?
    
    
    // MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isZoomEnabled = true
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupGestureRecognizer()
    }
    
    
    
    // MARK: - Gesture Related Functions
    
    private func setupGestureRecognizer() {
        longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressed(_:)))
        longGestureRecognizer.minimumPressDuration = 0.3
        
        mapView.addGestureRecognizer(longGestureRecognizer)
    }
    
    @objc private func handleLongPressed(_ gestureRecoginzer: UILongPressGestureRecognizer) {
        let location = gestureRecoginzer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        mapView.addAnnotation(annotation)
    }
    

}



// MARK: - MKMapViewDelegate

extension TravelLocationsMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let coordinate = view.annotation?.coordinate else { return }
 
        self.selectedLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.performSegue(withIdentifier: "goToPhotoAlbum", sender: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPhotoAlbum",
           let viewController = segue.destination as? PhotoAlbumViewController {
            viewController.selectedLocation = self.selectedLocation
        }
    }
}
