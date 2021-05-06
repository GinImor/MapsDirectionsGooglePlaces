//
// UITextField+constructor.swift
// MapsDirectionsGooglePlaces
//
// Created by Gin Imor on 5/5/21.
// 
//

import UIKit

extension UITextField {
  
  convenience init(placeholder: String) {
    self.init()
    self.placeholder = placeholder
  }
}