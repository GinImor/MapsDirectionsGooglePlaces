//
// Stack.swift
// GILibrary
//
// Created by Gin Imor on 4/19/21.
// Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

extension UIStackView {
  
  func spacing(_ value: CGFloat = 8.0) -> Self {
    spacing = value
    return self
  }
  
  func distributing(_ value: UIStackView.Distribution) -> Self {
    distribution = value
    return self
  }
  
  func aligning(_ value: UIStackView.Alignment) -> Self {
    alignment = value
    return self
  }
}

class GIStack: UIStackView {
  
  private override init(frame: CGRect) {
    super.init(frame: .zero)
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

class GIHStack: GIStack {

  convenience init(_ views: UIView...) {
    self.init(arrangedSubviews: views)
  }
  
  convenience init(_ views: [UIView]) {
    self.init(arrangedSubviews: views)
  }
}

class GIVStack: GIStack {
  
  convenience init(_ views: UIView...) {
    self.init(arrangedSubviews: views)
    axis = .vertical
  }
  
  convenience init(_ views: [UIView]) {
    self.init(arrangedSubviews: views)
    axis = .vertical
  }
}

