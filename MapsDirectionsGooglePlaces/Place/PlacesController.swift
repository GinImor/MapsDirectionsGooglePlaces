//
//  PlacesController.swift
//  MapsDirectionsGooglePlaces
//
//  Created by Gin Imor on 5/8/21.
//  
//

import SwiftUI
import GooglePlaces
import MapKit

class PlacesController: UIViewController {
  
  private lazy var mapView = MKMapView(frame: view.bounds)
  let locationManager = CLLocationManager()
  
  private func requestUserAuthorization() {
    locationManager.requestWhenInUseAuthorization()
    locationManager.delegate = self
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    requestUserAuthorization()
  }
  
  private func setupViews() {
    setupMapView()
  }
  
  private func setupMapView() {
    view.addSubview(mapView)
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    mapView.showsUserLocation = true
//    mapView.delegate = self
  }
  
  fileprivate func findNearbyPlaces() {
    GMSPlacesClient().currentPlace { [weak self] (likelihoodList, error) in
      if let error = error {
        print("find nearby places error", error)
        return
      }
      guard let strongSelf = self, let likelihoodList = likelihoodList else { return }
      let annotations = likelihoodList.likelihoods.map { likelihood -> MKAnnotation in
        let annotation = MKPointAnnotation()
        annotation.coordinate = likelihood.place.coordinate
        annotation.title = likelihood.place.name
        return annotation
      }
      strongSelf.mapView.addAnnotations(annotations)
      strongSelf.mapView.showAnnotations(strongSelf.mapView.annotations, animated: true)
    }
  }
}

extension PlacesController: CLLocationManagerDelegate {
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .authorizedWhenInUse:
      // if get the permission, go get the user position
      locationManager.startUpdatingLocation()
    default: ()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let firstLocation = locations.first else { return }
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let userRegion = MKCoordinateRegion(center: firstLocation.coordinate, span: span)
    mapView.setRegion(userRegion, animated: true)
    findNearbyPlaces()
  }
}

struct PlacesView: UIViewControllerRepresentable {
  
  func makeUIViewController(context: Context) -> some UIViewController {
    return PlacesController()
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
  }
}

struct PlacesView_Previews: PreviewProvider {
  static var previews: some View {
    PlacesView().edgesIgnoringSafeArea(.all)
  }
}
