//
//  DirectionsSearchView.swift
//  MapsDirectionsGooglePlaces
//
//  Created by Gin Imor on 5/10/21.
//  
//

import SwiftUI
import MapKit

struct DirectionsMapView: UIViewRepresentable {
  func makeUIView(context: Context) -> MKMapView {
    MKMapView()
  }
  
  func updateUIView(_ uiView: MKMapView, context: Context) {
    
  }
  
  typealias UIViewType = MKMapView
  
}

struct DirectionsSearchView: View {
    var body: some View {
      VStack(spacing: 0) {
        VStack(spacing: 16) {
          HStack(spacing: 16) {
            Image(uiImage: UIImage(systemName: "record.circle")!
                    .withRenderingMode(.alwaysTemplate))
              .foregroundColor(.white)
          Text("Resource")
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.white))
            .cornerRadius(3)
          }
          HStack(spacing: 16) {
            Image(uiImage: UIImage(systemName: "mappin.circle")!
                    .withRenderingMode(.alwaysTemplate))
              .foregroundColor(.white)
            Text("Destination")
              .padding(12)
              .frame(maxWidth: .infinity, alignment: .leading)
              .background(Color(.white))
              .cornerRadius(3)
          }
        }
        .padding()
        .background(Color(.brown).edgesIgnoringSafeArea(.top))
        DirectionsMapView()
      }.edgesIgnoringSafeArea(.bottom)
    }
}

struct DirectionsSearchView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsSearchView()
    }
}
