//
//  MapsDirectionsGooglePlacesApp.swift
//  MapsDirectionsGooglePlaces
//
//  Created by Gin Imor on 5/5/21.
//
//

import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    return true
  }
}

@main
struct MapsDirectionsGooglePlacesApp: App {
  // Add this line
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  var body: some Scene {
    WindowGroup {
      AppView().ignoresSafeArea()
    }
  }
}
