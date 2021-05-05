//
//  UIEdgeInsets+constructor.swift
//  GILibrary
//
//  Created by Gin Imor on 3/19/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
  
  init(top: CGFloat, leftRight: CGFloat, bottom: CGFloat) {
    self.init(top: top, left: leftRight, bottom: bottom, right: leftRight)
  }
  
  init(topBottom: CGFloat, left: CGFloat, right: CGFloat) {
    self.init(top: topBottom, left: left, bottom: topBottom, right: right)
  }
  
  init(vertical: CGFloat, horizontal: CGFloat) {
    self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
  }
  
  init(_ padding: CGFloat) {
    self.init(top: padding, left: padding, bottom: padding, right: padding)
  }
  
}
