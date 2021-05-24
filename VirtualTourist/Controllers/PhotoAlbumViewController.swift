//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Min Thet Maung on 19/05/2021.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate {

    
    // MARK: - Outlets & Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var newCollectionButton: RoundedButton!
    @IBOutlet weak var noPhotosFoundLabel: UILabel!
    var selectedLocation: CLLocation!
//    var pin: Pin!
    var dataController: DataController!
    private var photosInfo = [PhotoInfo]()
    
    
    
    // MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupCollectionView()
        
        fetchPhotos(coordinate: selectedLocation.coordinate)
        setupFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noPhotosFoundLabel.isHidden = true
        
        setCenterRegion(coordinate: selectedLocation.coordinate)
        addPin(coordinate: selectedLocation.coordinate)
    }
    
    
    //  MARK: - Initialization Functions
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupFlowLayout() {
        flowLayout.minimumLineSpacing = 1.0
        flowLayout.minimumInteritemSpacing = 1.0
    }
    
    
    // MARK: - Button Related Functions
    
    @IBAction func newCollectionButtonPressed(_ sender: Any) {
        self.fetchPhotos(coordinate: selectedLocation.coordinate)
    }
    
    private func setDownloadingState(isDownloading: Bool) {
        newCollectionButton.isEnabled = !isDownloading
        if isDownloading {
            newCollectionButton.setTitle("Downloading", for: .disabled)
        } else {
            newCollectionButton.setTitle("New Collection", for: .normal)
        }
        
    }
    
    
    // MARK: - Map Related Functions
    
    
    private func setCenterRegion(coordinate: CLLocationCoordinate2D) {
        let distance: CLLocationDistance = 100000.0
        let coordinate2D = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let region = MKCoordinateRegion(center: coordinate2D, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
    }
    
    private func addPin(coordinate: CLLocationCoordinate2D) {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
    
    
    
    // MARK: - Networking Related Functions

    private func fetchPhotos(coordinate: CLLocationCoordinate2D) {
        setDownloadingState(isDownloading: true)
        FlickrClient.getPhotosList(latitude: coordinate.latitude, longitude: coordinate.longitude) { (photosInfo, error) in
    
            self.noPhotosFoundLabel.isHidden = photosInfo.count > 0
            
            if let error = error {
                self.alertError(title: "Error in fetching photos", message: "\(error.localizedDescription)")
            }
            
            self.photosInfo = photosInfo
            self.collectionView.reloadData()
            self.setDownloadingState(isDownloading: false)
        }
    }
    
    private func alertError(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertVC, animated: true)
    }
    
    
}



// MARK: - UICollectionViewDelegateFlowLayout

extension PhotoAlbumViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 5) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 5, left: 2, bottom: 2, right: 0)
    }
    
}



// MARK: - UICollectionViewDataSource

extension PhotoAlbumViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.dataController = self.dataController
//        cell.setData(for: photosInfo[indexPath.item], pin: pin)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photosInfo.count
    }
    
    private func createPinView(annotation: MKAnnotation, reuseIdentifier: String) -> MKPinAnnotationView {
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        pinView.pinTintColor = .systemBlue
        return pinView
    }
}




extension PhotoAlbumViewController {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinId = "pinId"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = createPinView(annotation: annotation, reuseIdentifier: pinId)
            return pinView
        }
        
        pinView?.annotation = annotation
        return pinView
    }
}
