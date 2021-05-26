//
//  TravelLocationsMapViewController.swift
//  VirtualTourist
//
//  Created by Min Thet Maung on 19/05/2021.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsMapViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var mapView: MKMapView!
    var dataController: DataController!
    var longGestureRecognizer: UILongPressGestureRecognizer!
    private var selectedLocation: CLLocation?
    private var selectedPin: Pin!
    private var fetchedResultsController: NSFetchedResultsController<Pin>!

    
    // MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isZoomEnabled = true
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPinsFromStore()
        setupPinPointsOnMap()
        setupGestureRecognizer()
    }
    
    
    
    // MARK: - Gesture Related Functions
    
    private func setupGestureRecognizer() {
        longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressed(_:)))
        longGestureRecognizer.minimumPressDuration = 0.3
        
        mapView.addGestureRecognizer(longGestureRecognizer)
    }
    
    @objc private func handleLongPressed(_ gestureRecoginzer: UILongPressGestureRecognizer) {
        if gestureRecoginzer.state == .recognized {
            let location = gestureRecoginzer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            savePin(coordinate: coordinate)
        }
    }
    
    
    // MARK: - Pin Related Functions
   
    private func setupPinPointsOnMap() {
        var annotations = [MKPointAnnotation]()
        fetchedResultsController.fetchedObjects?.forEach {
            let annotation = createAnnotation(pin: $0)
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
    
    private func createCoordinate(latitude: Double, longitude: Double) -> CLLocationCoordinate2D {
        let lat = CLLocationDegrees(latitude)
        let lon = CLLocationDegrees(longitude)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        return coordinate
    }
    
    private func createAnnotation(pin: Pin) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = createCoordinate(latitude: pin.latitude, longitude: pin.longitude)
        return annotation
    }
    
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPhotoAlbum",
           let viewController = segue.destination as? PhotoAlbumViewController,
           let selectedLocation = self.selectedLocation {
            viewController.dataController = dataController
            viewController.selectedLocation = selectedLocation
            viewController.pin = selectedPin
            
            
        }
    }
    
}



// MARK: - MKMapViewDelegate

extension TravelLocationsMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let coordinate = view.annotation?.coordinate else { return }
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        selectedPin = fetchedResultsController.fetchedObjects?.filter {
            $0.latitude == latitude && $0.longitude == longitude
        }.first
        
        self.selectedLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        self.performSegue(withIdentifier: "goToPhotoAlbum", sender: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinId = "pinId"
        return setupAnnotationView(mapView, pinId: pinId, annotation: annotation)
    }
    
    
    
}




// MARK: - NSFetchedResultsControllerDelegate

extension TravelLocationsMapViewController: NSFetchedResultsControllerDelegate {
    
    private func loadPinsFromStore() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Error in fetching pins: \(error.localizedDescription)")
        }
    }

    private func savePin(coordinate: CLLocationCoordinate2D) {
        let pin = Pin(context: dataController.viewContext)
        pin.latitude = coordinate.latitude
        pin.longitude = coordinate.longitude
        try? dataController.viewContext.save()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            let pin = fetchedResultsController.object(at: newIndexPath!)
            addPinToMap(coordinate: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude))
        default: break
            
        }
    }
    
    
    private func addPinToMap(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    
}
