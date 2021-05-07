//
// UITextField+constructor.swift
// MapsDirectionsGooglePlaces
//
// Created by Gin Imor on 5/5/21.
// 
//

import UIKit

extension UITextField {
  
  convenience init(_ placeholder: String, _ textStyle: UIFont.TextStyle? = nil) {
    self.init()
    self.placeholder = placeholder
    if let textStyle = textStyle {
      self.font = UIFont.preferredFont(forTextStyle: textStyle)
    }
  }
}
