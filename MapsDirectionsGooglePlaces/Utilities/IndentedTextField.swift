//
//  IndentedTextField.swift
//  MapsDirectionsGooglePlaces
//
//  Created by Gin Imor on 5/7/21.
//  
//

import UIKit

class IndentedTextField: UITextField {
  
  let padding: CGFloat
  
  init(padding: CGFloat) {
    self.padding = padding
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override open func textRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.insetBy(dx: padding, dy: 0)
  }
  
  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.insetBy(dx: padding, dy: 0)
  }
}
