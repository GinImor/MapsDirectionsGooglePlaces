//
//  ContentView.swift
//  MapsDirectionsGooglePlaces
//
//  Created by Gin Imor on 5/5/21.
//
//

import SwiftUI
import MapKit
import Combine

extension MapController: LocationCarouselControllerDelegate {
  
  func didSelectItem(_ mapItem: MKMapItem) {
    mapView.showAnnotations([mapItem.placemark], animated: true)
  }
}


extension MapController: CLLocationManagerDelegate {
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .authorizedWhenInUse:
      print("change to when in use")
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
  }
}


extension MapController: MKMapViewDelegate {
  public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    // system create user annotation to show user position
    guard annotation is MKPlacemark else { return nil }
    let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationViewId")
    annotationView.canShowCallout = true
    return annotationView
  }
}


class MapController: UIViewController {
  
  private lazy var mapView = MKMapView(frame: view.bounds)
  
  private let searchTextField = UITextField(placeholder: "Enter to Search")
  private let donButton = UIButton.system(text: "Done")
  
  private var textFieldListener: AnyCancellable?
  
  private let locationCarouselController = LocationCarouselController(scrollDirection: .horizontal)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    performLocalSearch()
    requestUserAuthorization()
  }
  
  let locationManager = CLLocationManager()
  
  private func requestUserAuthorization() {
    locationManager.requestWhenInUseAuthorization()
    locationManager.delegate = self
  }
  
  private func performLocalSearch() {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = searchTextField.text
    request.region = mapView.region
    let localSearch = MKLocalSearch(request: request)
    localSearch.start { response, error in
      if let error = error {
        print("local search error", error)
        return
      }
      guard let response = response else { return }
      self.mapView.removeAnnotations(self.mapView.annotations)
      let annotations = response.mapItems.map { $0.placemark }
      self.mapView.addAnnotations(annotations)
      self.locationCarouselController.setItems(response.mapItems)
      self.mapView.showAnnotations(annotations, animated: true)
      if !annotations.isEmpty {
        self.locationCarouselController.collectionView.scrollToItem(at: [0, 0], at: .centeredHorizontally, animated: true)
      }
    }
  }
  
  
  private func setupViews() {
    view.backgroundColor = .clear
    setupMapView()
    setupSearchView()
    setupLocationsCarousel()
  }
  
  private func setupLocationsCarousel() {
    addChild(locationCarouselController)
    let carouselContainer = locationCarouselController.view!
    carouselContainer.add(to: view).hLining(.horizontal, to: view).vLining(.bottom).sizing(height: 150)
    locationCarouselController.didMove(toParent: self)
    locationCarouselController.delegate = self
  }
  
  private func setupSearchView() {
    let searchBackgroundView = UIView(backgroundColor: .white)
    GIHStack(searchTextField, donButton).spacing().view.add(to: searchBackgroundView).filling(edgeInsets: .init(8))
    searchBackgroundView.add(to: view).hLining(.horizontal, value: 16).vLining(.top, value: 16)
    
    // need to obtain the listener
    textFieldListener = NotificationCenter.default
      .publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .sink(receiveValue: { notification in
        self.performLocalSearch()
      })
    // old way to listen
    // searchTextField.addTarget(self, action: #selector(handleTap), for: .editingChanged)
    donButton.addTarget(self, action: #selector(handleDone))
  }
  
  @objc func handleDone() {
    searchTextField.resignFirstResponder()
  }
  
  @objc func handleTap() {
    print("23")
  }
  
  private func setupMapView() {
    view.addSubview(mapView)
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    mapView.showsUserLocation = true
    mapView.delegate = self
    setupRegion()
//    setupAnnotation()
  }
  
  private func setupAnnotation() {
    let appleCampusAnnotation = MKPointAnnotation()
    appleCampusAnnotation.coordinate = CLLocationCoordinate2D(latitude: 36.232600, longitude: -115.024034)
    appleCampusAnnotation.title = "Apple Campus"
    appleCampusAnnotation.subtitle = "CA"
    mapView.addAnnotation(appleCampusAnnotation)
  }
  
  private func setupRegion() {
    let coordinate = CLLocationCoordinate2D(latitude: 36.232600, longitude: -115.024034)
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    mapView.setRegion(region, animated: true)
  }
}


struct AppView: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> MapController {
    return MapController()
  }
  
  func updateUIViewController(_ uiViewController: MapController, context: Context) {
  }
  
  typealias UIViewControllerType = MapController
  
}


struct ContentView: View {
  var body: some View {
    Text("Hello World!")
      .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    AppView().ignoresSafeArea()
  }
  
}
