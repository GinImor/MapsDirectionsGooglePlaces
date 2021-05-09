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
    
  }
  
  typealias UIViewType = MKMapView
}

struct MapSearchingView: View {
    var body: some View {
      ZStack(alignment: .top) {
        MapSwiftUIView()
          .edgesIgnoringSafeArea(.all)
        HStack {
          Button(action: {
          }, label: {
            Text("Search for airports")
          })
          .padding()
          .background(Color(.white))
          Button(action: {
            print("123")
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
