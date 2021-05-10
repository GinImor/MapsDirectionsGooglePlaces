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

struct SelectLocationView: View {
  
  @Binding var isSelectingSource: Bool
  @State var mapItems = [MKMapItem]()
  @State var searchQuery = ""
  
  var body: some View {
    
    VStack {
      
      HStack {
        Button(action: {
          isSelectingSource = false
        }, label: {
          Image(uiImage: UIImage(systemName: "arrow.left")!)
        })
        
        TextField("Enter search query", text: $searchQuery)
          .onReceive(
            NotificationCenter.default.publisher(
              for: UITextField.textDidChangeNotification)
              .debounce(for: .milliseconds(500), scheduler: RunLoop.main), perform: { _ in
                let request = MKLocalSearch.Request()
                // no need to concern reference cycle, cause it's struct!
                request.naturalLanguageQuery = self.searchQuery
                let localSearch = MKLocalSearch(request: request)
                localSearch.start { (response, error) in
                  if let error = error {
                    print("local search error in SelecLocationView", error)
                    return
                  }
                  guard let response = response else { return }
                  self.mapItems = response.mapItems
                }
              })
      }
      
      ScrollView {
        ForEach(mapItems, id: \.self) { mapItem in
          HStack {
            VStack(alignment: .leading, spacing: 8) {
              Text(mapItem.name ?? "").font(.headline)
              Text(mapItem.address)
            }
            Spacer()
          }
          .padding(.vertical, 8)
        }
      }
      
    }
    .padding(.horizontal, 16)
    .navigationBarHidden(true)
  }
}

struct DirectionsSearchView: View {
  
  @State var isSelectingSource: Bool = false
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        VStack(spacing: 16) {
          HStack(spacing: 16) {
            Image(uiImage: UIImage(systemName: "record.circle")!
                    .withRenderingMode(.alwaysTemplate))
              .foregroundColor(.white)
            NavigationLink(
              destination: SelectLocationView(isSelectingSource: $isSelectingSource),
              isActive: $isSelectingSource,
              label: {
                Text("Resource")
                  .padding(12)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .background(Color(.white))
                  .cornerRadius(3)
              })
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
      // don't set it in navigation view
      .navigationBarHidden(true)
    }
  }
  
}

struct DirectionsSearchView_Previews: PreviewProvider {
  static var previews: some View {
    DirectionsSearchView()
  }
}
