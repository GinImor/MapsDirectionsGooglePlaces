//
// UIStackView+padding.swift
// GILibrary
//
// Created by Gin Imor on 4/18/21.
// Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

enum Direction {
  case top, left, bottom, right, all
}

extension UIStackView {
  
  @discardableResult
  func padding(_ direction: Direction, value: CGFloat = 16) -> UIStackView {
    isLayoutMarginsRelativeArrangement = true
    switch direction {
    case .top: layoutMargins.top = value
    case .left: layoutMargins.left = value
    case .bottom: layoutMargins.bottom = value
    case .right: layoutMargins.right = value
    case .all: layoutMargins = UIEdgeInsets(8)
    }
    return self
  }
  
  @discardableResult
  func padding(edgeInsets: UIEdgeInsets = .init(16)) -> UIStackView {
    isLayoutMarginsRelativeArrangement = true
    layoutMargins = edgeInsets
    return self
  }
  
}
