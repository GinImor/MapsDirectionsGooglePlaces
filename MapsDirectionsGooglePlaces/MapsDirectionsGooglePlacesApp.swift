//
//  MapsDirectionsGooglePlacesApp.swift
//  MapsDirectionsGooglePlaces
//
//  Created by Gin Imor on 5/5/21.
//
//

import SwiftUI
import UIKit
import GooglePlaces

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // paste API key below, unfortunatelly, in order to make the key work
    // need billing account
//    GMSPlacesClient.provideAPIKey("")
    return true
  }
}

@main
struct MapsDirectionsGooglePlacesApp: App {
  // Add this line
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  var body: some Scene {
    WindowGroup {
      MapSearchingView()
    }
  }
}
