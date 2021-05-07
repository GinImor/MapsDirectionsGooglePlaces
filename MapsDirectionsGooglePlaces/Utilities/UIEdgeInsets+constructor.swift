//
//  UIEdgeInsets+constructor.swift
//  GILibrary
//
//  Created by Gin Imor on 3/19/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
  
  init(_ top: CGFloat, _ leftRight: CGFloat, _ bottom: CGFloat) {
    self.init(top: top, left: leftRight, bottom: bottom, right: leftRight)
  }
  
  init(_ vertical: CGFloat, _ horizontal: CGFloat) {
    self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
  }
  
  init(_ allSides: CGFloat) {
    self.init(top: allSides, left: allSides, bottom: allSides, right: allSides)
  }
  
}
