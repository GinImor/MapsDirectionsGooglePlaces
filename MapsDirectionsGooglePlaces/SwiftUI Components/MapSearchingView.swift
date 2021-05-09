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

struct MapSearchingView: View {
  
  @State var annotations = [MKAnnotation]()
  
  var body: some View {
    ZStack(alignment: .top) {
      MapSwiftUIView(annotations: annotations)
        .edgesIgnoringSafeArea(.all)
      HStack {
        Button(action: {
          performSearch(query: "airports")
        }, label: {
          Text("Search for airports")
        })
        .padding()
        .background(Color(.white))
        Button(action: {
          annotations = []
        }, label: {
          Text("Clear annotations")
        })
        .padding()
        .background(Color(.white))
      }.shadow(radius: 2)
    }
  }
  
  private func performSearch(query: String) {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = query
    let localSearch = MKLocalSearch(request: request)
    localSearch.start { (response, error) in
      if let error = error {
        print("local search error in MapSearchingView", error)
        return
      }
      guard let response = response else { return }
      annotations = response.mapItems.map { mapItem -> MKAnnotation in
        let annotation = MKPointAnnotation()
        annotation.title = mapItem.name
        annotation.coordinate = mapItem.placemark.coordinate
        return annotation
      }
    }
  }
}

struct MapSearchingView_Previews: PreviewProvider {
  static var previews: some View {
    MapSearchingView()
  }
}
