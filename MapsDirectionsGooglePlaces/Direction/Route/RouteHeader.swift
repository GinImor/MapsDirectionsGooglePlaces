//
//  RouteHeader.swift
//  MapsDirectionsGooglePlaces
//
//  Created by Gin Imor on 5/8/21.
//  
//

import SwiftUI
import UIKit
import MapKit

extension TimeInterval {
  
  var hsMs: String {
    var minutes = Int(self) / 60
    let hours = minutes / 60
    minutes = minutes % 60
    if hours != 0 { return "\(hours) hr \(minutes) min" }
    else { return "\(minutes) min" }
  }
}

class RouteHeader: UICollectionReusableView {
  
  let routeNameLabel = UILabel.new("Route: ")
  let distanceLabel = UILabel.new("Distance: ")
  let estimatedTimeLabel = UILabel.new("Est Time: ")
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    GIVStack(routeNameLabel, distanceLabel, estimatedTimeLabel).spacing()
      .add(to: self).hLining(.horizontal, value: 16).vLining(.centerY)
  }
  
  func configureViewWith(route: MKRoute) {
    routeNameLabel.attributedText = attributedText("Route: ", content: route.name)
    distanceLabel.attributedText = attributedText("Distance: ", content: route.distance.milesString)
    estimatedTimeLabel.attributedText = attributedText("Est Time: ", content: route.expectedTravelTime.hsMs)
    print("route header expectedTravelTime", route.expectedTravelTime)
  }
 
  private func attributedText(_ title: String, content: String) -> NSAttributedString {
    let result = NSMutableAttributedString(string: title, attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
    result.append(NSAttributedString(string: content, attributes: [.font: UIFont.systemFont(ofSize: 16)]))
    return result
  }
}

struct RouteSwiftUIHeader: UIViewRepresentable {
  
  func makeUIView(context: Context) -> some UIView {
    RouteHeader()
  }
  func updateUIView(_ uiView: UIViewType, context: Context) {
  }
}


struct RouteHeader_Previews: PreviewProvider {
    static var previews: some View {
      RouteSwiftUIHeader()
    }
}

