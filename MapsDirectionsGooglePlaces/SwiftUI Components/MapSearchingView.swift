//
//  MapSearchingView.swift
//  MapsDirectionsGooglePlaces
//
//  Created by Gin Imor on 5/8/21.
//  
//

import SwiftUI
import MapKit

struct MapSwiftUIView: UIViewRepresentable {
  
  var annotations: [MKAnnotation]
  
  let mapView = MKMapView()
  
  private func setupRegion() {
    let coordinate = CLLocationCoordinate2D(latitude: 36.232600, longitude: -115.024034)
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    mapView.setRegion(region, animated: true)
  }
  
  func makeUIView(context: Context) -> MKMapView {
    setupRegion()
    return mapView
  }
  
  func updateUIView(_ uiView: MKMapView, context: Context) {
    uiView.removeAnnotations(uiView.annotations)
    uiView.addAnnotations(annotations)
    uiView.showAnnotations(annotations, animated: true)
  }
  
  typealias UIViewType = MKMapView
}

class MapSearchingViewModel: ObservableObject {
  
  @Published var annotations = [MKAnnotation]()
  
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
      MapSwiftUIView(annotations: mapSearchingViewModel.annotations)
        .edgesIgnoringSafeArea(.all)
      HStack {
        Button(action: {
          mapSearchingViewModel.performSearch(query: "airports")
        }, label: {
          Text("Search for airports")
        })
        .padding()
        .background(Color(.white))
        Button(action: {
          mapSearchingViewModel.annotations = []
        }, label: {
          Text("Clear annotations")
        })
        .padding()
        .background(Color(.white))
      }.shadow(radius: 2)
    }
  }
  
}

struct MapSearchingView_Previews: PreviewProvider {
  static var previews: some View {
    MapSearchingView()
  }
}
