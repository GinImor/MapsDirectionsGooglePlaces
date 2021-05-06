//
// LocationCarouselCell.swift
// MapsDirectionsGooglePlaces
//
// Created by Gin Imor on 5/6/21.
// 
//

import UIKit

class LocationCarouselCell: GIListCell<UIColor> {
  
  override func setup() {
    super.setup()
    layer.cornerRadius = 8
    shadow(opacity: 1.0, radius: 4, offset: CGSize(width: 0.0, height: 1.0))
  }
  
  override func didSetItem() {
    backgroundColor = item
  }
}
