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

class DirectionsController: UIViewController, MKMapViewDelegate {
  
  let mapView = MKMapView()
  let navBar = UIView(backgroundColor: .red)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    requestDirections()
  }
  
  func requestDirections() {
    let sourceCoordinate = CLLocationCoordinate2D(latitude: 31.224849, longitude: 121.493868)
    let destinationCoordinate = CLLocationCoordinate2D(latitude: 31.213959, longitude: 121.430968)
    let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
    let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
    let source = MKMapItem(placemark: sourcePlacemark)
    let destination = MKMapItem(placemark: destinationPlacemark)
    let request = MKDirections.Request()
    request.source = source
    request.destination = destination
    
    let directions = MKDirections(request: request)
    directions.calculate { (response, error) in
      if let error = error {
        print("calculate routes error", error)
        return
      }
      guard let route = response?.routes.first else { return }
      self.mapView.addOverlay(route.polyline)
    }
  }
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = .red
    renderer.lineWidth = 5
    return renderer
  }
  
  func setupViews() {
    setupRegion()
    setupNavBar()
    setupMapView()
    setupDummyAnnotations()
  }
  
  func setupDummyAnnotations() {
    let annotation1 = MKPointAnnotation()
    annotation1.coordinate = .init(latitude: 31.224849, longitude: 121.493868)
    annotation1.title = "Start"
    
    let annotation2 = MKPointAnnotation()
    annotation2.coordinate = .init(latitude: 31.213959, longitude: 121.430968)
    annotation2.title = "End"
    
    mapView.addAnnotations([annotation1, annotation2])
    mapView.showAnnotations(mapView.annotations, animated: true)
  }
  
  private func setupMapView() {
    mapView.add(to: view).hLining(.horizontal, to: view)
      .vLining(.bottom, to: view).vLining(.top, to: navBar, .bottom)
    mapView.showsUserLocation = true
    mapView.delegate = self
  }
  
  private lazy var sourceTextField = navBarTextFiled(placeholder: "Source")
  private lazy var destinationTextField = navBarTextFiled(placeholder: "Destination")
  
  private func setupNavBar() {
    navBar.add(to: view).hLining(.horizontal, to: view)
      .vLining(.top, to: view).vLining(.bottom, .top, value: 100)
    GIVStack(
      GIHStack(
        UIImageView.system(imageName: "record.circle", size: 22, tintColor: .white),
        sourceTextField.withCH(249, axis: .horizontal)).spacing(),
      GIHStack(
        UIImageView.system(imageName: "mappin.circle", size: 22, tintColor: .white),
        destinationTextField.withCH(249, axis: .horizontal)).spacing()
    )
    .distributing(.fillEqually).spacing().add(to: navBar)
    .filling(edgeInsets: .init(top: 0, left: 16, bottom: 8, right: 16))
  }
  
  
  private func setupRegion() {
    let coordinate = CLLocationCoordinate2D(latitude: 31.224849, longitude: 121.493868)
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    mapView.setRegion(region, animated: true)
  }
  
  private func navBarTextFiled(placeholder: String) -> IndentedTextField {
    let textField = IndentedTextField(padding: 8)
    textField.layer.cornerRadius = 8
    textField.textColor = .white
    textField.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
    let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1.0, alpha: 0.7)]
    textField.attributedPlaceholder = .init(string: placeholder, attributes: placeholderAttributes)
    return textField
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
