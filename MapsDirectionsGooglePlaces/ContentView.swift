//
//  ContentView.swift
//  MapsDirectionsGooglePlaces
//
//  Created by Gin Imor on 5/5/21.
//
//

import SwiftUI
import MapKit

class MapController: UIViewController {
    
    private lazy var mapView = MKMapView(frame: view.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .systemBackground
        view.addSubview(mapView)
        mapView.mapType = .satellite
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello World!")
            .padding()
    }
}

class ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
    #if DEBUG
    @objc class func injected() {
        UIApplication.shared.windows.first?.rootViewController =
          MapController()
//          UIHostingController(rootView: ContentView_Previews.previews)
    }
    #endif
}