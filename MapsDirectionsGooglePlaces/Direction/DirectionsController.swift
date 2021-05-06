//
//  DirectionsController.swift
//  MapsDirectionsGooglePlaces
//
//  Created by Gin Imor on 5/6/21.
//
//

import UIKit
import SwiftUI
import MapKit

class DirectionsController: UIViewController {
  
  let mapView = MKMapView()
  let navBar = UIView(backgroundColor: .red)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  func setupViews() {
    setupRegion()
    setupNavBar()
    setupMapView()
    setupDumyAnnotations()
  }
  
  func setupDumyAnnotations() {
    let annotation1 = MKPointAnnotation()
    annotation1.coordinate = .init(latitude: 37.7666, longitude: -122.427290)
    annotation1.title = "Start"
    
    let annotation2 = MKPointAnnotation()
    annotation2.coordinate = .init(latitude: 37.331352, longitude: -122.030331)
    annotation2.title = "End"
    
    mapView.addAnnotations([annotation1, annotation2])
    mapView.showAnnotations(mapView.annotations, animated: true)
  }
  
  private func setupMapView() {
    mapView.add(to: view).hLining(.horizontal, to: view)
      .vLining(.bottom, to: view).vLining(.top, to: navBar, .bottom)
    mapView.showsUserLocation = true
  }
  
  private func setupNavBar() {
    navBar.add(to: view).hLining(.horizontal, to: view)
      .vLining(.top, to: view).vLining(.bottom, .top, value: 100)
  }
  
  
  private func setupRegion() {
    let coordinate = CLLocationCoordinate2D(latitude: 36.232600, longitude: -115.024034)
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    mapView.setRegion(region, animated: true)
  }

}

struct DirectionsView: UIViewControllerRepresentable {
  
  func makeUIViewController(context: Context) -> some UIViewController {
    return DirectionsController()
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
  }
}

struct DirectionsView_Preview: PreviewProvider {
  static var previews: some View {
    DirectionsView().edgesIgnoringSafeArea(.all)
  }
}
