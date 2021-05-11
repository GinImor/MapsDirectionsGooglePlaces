//
//  DirectionsSearchView.swift
//  MapsDirectionsGooglePlaces
//
//  Created by Gin Imor on 5/10/21.
//  
//

import SwiftUI
import MapKit
import Combine

struct DirectionsMapView: UIViewRepresentable {

  @EnvironmentObject var env: DirectionsEnvironment
  
  let mapView = MKMapView()

  func makeCoordinator() -> Coordinator {
    Coordinator(mapView: mapView)
  }
  
  class Coordinator: NSObject, MKMapViewDelegate {
    
    init(mapView: MKMapView) {
      super.init()
      mapView.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      let renderer = MKPolylineRenderer(overlay: overlay)
      renderer.strokeColor = .brown
      renderer.lineWidth = 5
      return renderer
    }
  }
  
  func makeUIView(context: Context) -> MKMapView {
    return mapView
  }
  
  func updateUIView(_ uiView: MKMapView, context: Context) {
    // remember, every time env publish, this method will be called
    uiView.removeOverlays(uiView.overlays)
    uiView.removeAnnotations(uiView.annotations)
    
    let annotations = [env.sourceMapItem, env.destinationMapItem]
      .compactMap{$0}.map { mapItem -> MKAnnotation in
      let annotation = MKPointAnnotation()
      annotation.title = mapItem.name
      annotation.coordinate = mapItem.placemark.coordinate
      return annotation
    }
    uiView.addAnnotations(annotations)
    uiView.showAnnotations(annotations, animated: false)
    
    if let route = env.route {
      uiView.addOverlay(route.polyline)
    }
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
                    print("local search error in SelectLocationView", error)
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

struct MapItemView: View {
  
  @EnvironmentObject var env: DirectionsEnvironment
  
  var isSource: Bool
  
  var imageName: String {
    isSource ? "record.circle" : "mappin.circle"
  }
  
  var textTitle: String {
    isSource ? env.sourceMapItem?.name ?? "Source" : env.destinationMapItem?.name ?? "Destination"
  }
  
  var isSelectingSource: Binding<Bool> {
    isSource ? $env.isSelectingSource : $env.isSelectingDestination
  }
  
  var body: some View {
    HStack(spacing: 16) {
      Image(uiImage: UIImage(systemName: imageName)!
              .withRenderingMode(.alwaysTemplate))
        .foregroundColor(.white)
      NavigationLink(
        destination: SelectLocationView(),
        isActive: isSelectingSource,
        label: {
          Text(textTitle)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.white))
            .cornerRadius(3)
        })
    }
  }
}

struct DirectionsSearchView: View {
  
  @EnvironmentObject var env: DirectionsEnvironment
  
  var body: some View {
    NavigationView {
      ZStack {
        VStack(spacing: 0) {
          VStack(spacing: 16) {
            MapItemView(isSource: true)
            MapItemView(isSource: false)
          }
          .padding()
          .background(Color(.brown).edgesIgnoringSafeArea(.top))
          // here, mapView act as Spacer(), fill up the remaining space
          DirectionsMapView()
        }.edgesIgnoringSafeArea(.bottom)
        // don't set it in navigation view
        .navigationBarHidden(true)
        
        if env.isCalculatingDirections {
          LoadingView()
        }
      }
    }
  }
  
}

struct LoadingView: View {
  
  var body: some View {
    VStack {
      LoadingSwiftUIHUB()
      Text("Loading...")
        .foregroundColor(.white)
    }
    .padding()
    .background(Color(.black))
    .cornerRadius(5)
  }
}

struct LoadingSwiftUIHUB: UIViewRepresentable {
  
  func makeUIView(context: Context) -> UIActivityIndicatorView {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.color = .white
    indicator.startAnimating()
    return indicator
  }
  
  func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
  }

  typealias UIViewType = UIActivityIndicatorView
}

class DirectionsEnvironment: ObservableObject {
  @Published var isSelectingSource = false
  @Published var isSelectingDestination = false
  @Published var sourceMapItem: MKMapItem?
  @Published var destinationMapItem: MKMapItem?
  
  @Published var route: MKRoute?
  @Published var isCalculatingDirections = false
  
  var mapItemListener: AnyCancellable?
  
  init() {
    // listen for the new value of mapItems, calculate the route if necessary
    // DirectionsMapView responsable for drawing the mapItems and route
    mapItemListener = Publishers.CombineLatest($sourceMapItem, $destinationMapItem).sink { [weak self] (output) in
      let request = MKDirections.Request()
      request.source = output.0
      request.destination = output.1
      let directions = MKDirections(request: request)
      self?.isCalculatingDirections = true
      directions.calculate { [weak self] (response, error) in
        self?.isCalculatingDirections = false
        if let error = error {
          print("calculate directions error", error)
          return
        }
        self?.route = response?.routes.first
      }
    }
  }
}

struct DirectionsSearchView_Previews: PreviewProvider {
  static var env = DirectionsEnvironment()
  
  static var previews: some View {
    DirectionsSearchView().environmentObject(env)
  }
}
