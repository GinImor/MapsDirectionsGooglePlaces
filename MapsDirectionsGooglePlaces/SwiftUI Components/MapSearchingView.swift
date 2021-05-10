//
//  MapSearchingView.swift
//  MapsDirectionsGooglePlaces
//
//  Created by Gin Imor on 5/8/21.
//  
//

import SwiftUI
import MapKit
import Combine

struct MapSwiftUIView: UIViewRepresentable {
  func makeCoordinator() -> Coordinator {
    Coordinator(mapView: mapView)
  }
  
  var annotations: [MKAnnotation]
  var selectedAnnotation: MKAnnotation?

  let mapView = MKMapView()
  
  var currentUserCoordinate: CLLocationCoordinate2D?
  
  class Coordinator: NSObject, MKMapViewDelegate {
    
    init(mapView: MKMapView) {
      super.init()
      mapView.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      guard annotation is MKPointAnnotation else { return nil }
      let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotionView")
      annotationView.canShowCallout = true
      return annotationView
    }
  }
  
  private func setupRegion() {
    let coordinate = CLLocationCoordinate2D(latitude: 36.232600, longitude: -115.024034)
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    mapView.setRegion(region, animated: true)
  }
  
  func makeUIView(context: Context) -> MKMapView {
    setupRegion()
    mapView.showsUserLocation = true
    return mapView
  }
  
  func updateUIView(_ uiView: MKMapView, context: Context) {
    if let currentUserCoordinate = currentUserCoordinate {
      let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
      let region = MKCoordinateRegion(center: currentUserCoordinate, span: span)
      uiView.setRegion(region, animated: true)
    }
    if annotations.isEmpty {
      uiView.removeAnnotations(uiView.annotations)
      return
    }
    var isRefreshing = false
    if needRefreshAnnotations(uiView) {
      isRefreshing = true
      uiView.removeAnnotations(uiView.annotations)
      uiView.addAnnotations(annotations)
      uiView.showAnnotations(annotations, animated: true)
    }
    if !isRefreshing, let selectedAnnotation = selectedAnnotation {
      uiView.selectAnnotation(selectedAnnotation, animated: true)
    }
  }
  
  private func needRefreshAnnotations(_ uiView: MKMapView) -> Bool {
    let groupedAnnotations = Dictionary(grouping: uiView.annotations, by: { $0.title })
    for annotation in annotations {
      if groupedAnnotations[annotation.title] == nil {
        return true
      }
    }
    return false
  }
  
  typealias UIViewType = MKMapView
}

class MapSearchingViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
  
  @Published var annotations = [MKAnnotation]()
  @Published var searchTerm = ""
  @Published var mapItems = [MKMapItem]()
  
  @Published var selectedAnnotation: MKAnnotation?
  
  @Published var currentUserCoordinate: CLLocationCoordinate2D?
  
  var searchTermListener: AnyCancellable?
  
  let locationManager = CLLocationManager()
  
  override init() {
    super.init()
    searchTermListener = $searchTerm.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .sink { [weak self] (searchQuery) in
        self?.performSearch(query: searchQuery)
      }
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    if manager.authorizationStatus == .authorizedWhenInUse {
      manager.startUpdatingLocation()
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    currentUserCoordinate = locations.first?.coordinate
  }
  
  fileprivate func performSearch(query: String) {
    // if request not specify region, then the local search
    // will based on the network the user currently on
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = query
    let localSearch = MKLocalSearch(request: request)
    localSearch.start { (response, error) in
      if let error = error {
        print("local search error in MapSearchingView", error)
        return
      }
      guard let response = response else { return }
      self.mapItems = response.mapItems
      self.annotations = response.mapItems.map { mapItem -> MKAnnotation in
        let annotation = MKPointAnnotation()
        annotation.title = mapItem.name
        annotation.coordinate = mapItem.placemark.coordinate
        return annotation
      }
    }
  }
  
}

struct MapSearchingView: View {
  // once the ObservedObject publish something, the listeners will be
  // notified, and update the relative views, in this case, the MapSwiftUIView
  // the map view receive new annotations, trigger the updateUIView method
  @ObservedObject var mapSearchingViewModel = MapSearchingViewModel()
  
  var body: some View {
    ZStack(alignment: .top) {
      MapSwiftUIView(annotations: mapSearchingViewModel.annotations, selectedAnnotation: mapSearchingViewModel.selectedAnnotation, currentUserCoordinate: mapSearchingViewModel.currentUserCoordinate)
        .edgesIgnoringSafeArea(.all)
      VStack(spacing: 8) {
        HStack {
          TextField("Search terms", text: $mapSearchingViewModel.searchTerm)
            .padding()
            .background(Color(.white))
        }.padding(.horizontal)
        Spacer()
        ScrollView(.horizontal) {
          HStack {
            ForEach(Array(zip(mapSearchingViewModel.annotations.indices, mapSearchingViewModel.annotations)), id: \.0) { (index, annotation) in
              Button(action: {
                mapSearchingViewModel.selectedAnnotation = mapSearchingViewModel.annotations[index]
              }, label: {
                VStack(alignment: .leading) {
                  Text("\(mapSearchingViewModel.mapItems[index].name ?? "")").font(.headline)
                  Text("\(mapSearchingViewModel.mapItems[index].placemark.title ?? "")")
                }
                .frame(width: 200)
                .padding().background(Color(.white))
                .cornerRadius(3.0)
              })
              .foregroundColor(.black)
            }
          }.padding(.horizontal)
        }.shadow(radius: 5.0)
      }
    }
  }
  
}

struct MapSearchingView_Previews: PreviewProvider {
  static var previews: some View {
    MapSearchingView()
  }
}
