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
import JGProgressHUD

class DirectionsController: UIViewController, MKMapViewDelegate {
  
  let mapView = MKMapView()
  let navBar = UIView(backgroundColor: .red)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  let routingHud: JGProgressHUD = {
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Routing"
    return hud
  }()
  
  func requestDirections() {
    let source = sourceMapItem
    let destination = destinationMapItem
    let request = MKDirections.Request()
    request.source = source
    request.destination = destination
    
    routingHud.show(in: view)
    let directions = MKDirections(request: request)
    directions.calculate { (response, error) in
      self.routingHud.dismiss()
      if let error = error {
        print("calculate routes error", error)
        return
      }
      guard let route = response?.routes.first else { return }
      self.showingRoute = route
      self.mapView.addOverlay(route.polyline)
    }
  }
  
  private var showingRoute: MKRoute?
  
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
    setupRouteButton()
  }
  
  let routeButton = UIButton.system(text: "Route", tintColor: .black)
  
  func setupRouteButton() {
    routeButton.backgroundColor = .white
    routeButton.addTarget(self, action: #selector(showRoute))
    routeButton.add(to: view).hLining(.horizontal, value: 16).vLining(.bottom, value: -16).sizing(height: 50)
  }
  
  @objc func showRoute() {
    guard let showingRoute = showingRoute else { return }
    let routesController = RoutesController()
    routesController.route = showingRoute
    present(routesController, animated: true)
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
    navigationController?.navigationBar.isHidden = true
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
    .distributing(.fillEqually).spacing()
    .add(to: navBar).filling(edgeInsets: .init(0, 16, 8))
  }
  
  
  private func setupRegion() {
    let coordinate = CLLocationCoordinate2D(latitude: 31.224849, longitude: 121.493868)
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    mapView.setRegion(region, animated: true)
  }
  
  private func navBarTextFiled(placeholder: String) -> IndentedTextField {
    let textField = IndentedTextField(8)
    textField.layer.cornerRadius = 8
    textField.textColor = .white
    textField.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
    textField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    let placeholderAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1.0, alpha: 0.7)]
    textField.attributedPlaceholder = .init(string: placeholder, attributes: placeholderAttributes)
    return textField
  }
  
  private var sourceAnnotation: MKPointAnnotation!
  private var destinationAnnotation: MKPointAnnotation!
  private var sourceMapItem: MKMapItem!
  private var destinationMapItem: MKMapItem!
  
  @objc func handleTap(_ sender: UITapGestureRecognizer) {
    if let tappedTextField = sender.view as? UITextField {
      let locationSearchController = LocationSearchController()
      locationSearchController.didSelectMapItem = { [unowned self] mapItem in
        tappedTextField.text = mapItem.name
        if tappedTextField === self.sourceTextField {
          if sourceAnnotation == nil {
            sourceAnnotation = MKPointAnnotation()
            mapView.addAnnotation(sourceAnnotation)
          }
          self.sourceMapItem = mapItem
          self.refreshAnnotation(self.sourceAnnotation, withItem: mapItem)
        } else if tappedTextField === self.destinationTextField {
          if destinationAnnotation == nil {
            destinationAnnotation = MKPointAnnotation()
            mapView.addAnnotation(destinationAnnotation)
          }
          self.destinationMapItem = mapItem
          self.refreshAnnotation(self.destinationAnnotation, withItem: mapItem)
        }
      }
    navigationController?.pushViewController(locationSearchController, animated: true)
    }
  }

  private func refreshAnnotation(_ annotation: MKPointAnnotation, withItem mapItem: MKMapItem) {
    guard annotation.title != mapItem.name else { return }
    mapView.removeOverlays(mapView.overlays)
    annotation.coordinate = mapItem.placemark.coordinate
    annotation.title = mapItem.name
    mapView.showAnnotations(mapView.annotations, animated: true)
    if sourceAnnotation != nil && destinationAnnotation != nil {
      requestDirections()
    }
  }

}

struct DirectionsView: UIViewControllerRepresentable {
  
  func makeUIViewController(context: Context) -> some UIViewController {
    return UINavigationController(rootViewController: DirectionsController())
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
  }
}

struct DirectionsView_Preview: PreviewProvider {
  static var previews: some View {
    DirectionsView().edgesIgnoringSafeArea(.all)
  }
}
