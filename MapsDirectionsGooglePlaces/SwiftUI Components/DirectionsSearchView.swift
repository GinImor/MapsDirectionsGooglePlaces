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
  
  @EnvironmentObject var env: DirectionsEnvironment
  
  @State var mapItems = [MKMapItem]()
  @State var searchQuery = ""
  
  var body: some View {
    
    VStack {
      
      HStack {
        Button(action: {
          env.isSelectingSource = false
          env.isSelectingDestination = false
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
          Button(action: {
            if env.isSelectingSource {
              env.sourceMapItem = mapItem
              env.isSelectingSource = false
            } else if env.isSelectingDestination {
              env.destinationMapItem = mapItem
              env.isSelectingDestination = false
            }
          }, label: {
            HStack {
              VStack(alignment: .leading, spacing: 8) {
                Text(mapItem.name ?? "").font(.headline)
                Text(mapItem.address)
              }
              Spacer()
            }
            .padding(.vertical, 8)
          })
          .foregroundColor(.black)
        }
      }
      
    }
    .padding(.horizontal, 16)
    .navigationBarHidden(true)
  }
}

struct DirectionsSearchView: View {
  
  @EnvironmentObject var env: DirectionsEnvironment
  
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        VStack(spacing: 16) {
          HStack(spacing: 16) {
            Image(uiImage: UIImage(systemName: "record.circle")!
                    .withRenderingMode(.alwaysTemplate))
              .foregroundColor(.white)
            NavigationLink(
              destination: SelectLocationView(),
              isActive: $env.isSelectingSource,
              label: {
                Text(env.sourceMapItem?.name ?? "Source")
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
            NavigationLink(
              destination: SelectLocationView(),
              isActive: $env.isSelectingDestination,
              label: {
                Text(env.destinationMapItem?.name ?? "Destination")
                  .padding(12)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .background(Color(.white))
                  .cornerRadius(3)
              })
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

class DirectionsEnvironment: ObservableObject {
  @Published var isSelectingSource = false
  @Published var isSelectingDestination = false
  @Published var sourceMapItem: MKMapItem?
  @Published var destinationMapItem: MKMapItem?
}

struct DirectionsSearchView_Previews: PreviewProvider {
  static var env = DirectionsEnvironment()
  
  static var previews: some View {
    DirectionsSearchView().environmentObject(env)
  }
}
