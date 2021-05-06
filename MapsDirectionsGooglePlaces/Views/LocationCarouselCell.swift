//
// LocationCarouselCell.swift
// MapsDirectionsGooglePlaces
//
// Created by Gin Imor on 5/6/21.
// 
//

import UIKit
import MapKit

class LocationCarouselCell: GIListCell<MKMapItem> {
  
  let titleLabel = UILabel.new("Title", .subheadline)
  let addressLabel = UILabel.new("Address", .footnote, 0)
  let coordinateLabel = UILabel.new("0 - 0", .caption1)
  
  override func setup() {
    super.setup()
    layer.cornerRadius = 8
    shadow(opacity: 1.0, radius: 4, offset: CGSize(width: 0.0, height: 1.0))
    
    GIVStack(titleLabel, GIVStack(addressLabel, UIView()).view, coordinateLabel)
      .spacing().view.add(to: self).filling(edgeInsets: .init(8))
  }
  
  override func didSetItem() {
    titleLabel.text = item.name
    addressLabel.text = item.address
    let coordinate = item.placemark.coordinate
    coordinateLabel.text = "\(coordinate.latitude)  ––  \(coordinate.longitude)"
  }
}
