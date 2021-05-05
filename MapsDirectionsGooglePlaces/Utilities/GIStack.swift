//
// Stack.swift
// GILibrary
//
// Created by Gin Imor on 4/19/21.
// Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

protocol GIStack {
  var view: UIStackView { get }
}

extension GIStack {
  
  func spacing(_ value: CGFloat = 8.0) -> GIStack {
    view.spacing = value
    return self
  }
  
  func distribution(_ value: UIStackView.Distribution) -> GIStack {
    view.distribution = value
    return self
  }
  
  func aliment(_ value: UIStackView.Alignment) -> GIStack {
    view.alignment = value
    return self
  }
}

struct GIHStack: GIStack {
  let view: UIStackView
  
  init(_ views: UIView...) {
    view = UIStackView(arrangedSubviews: views)
  }
  
  init(_ views: [UIView]) {
    view = UIStackView(arrangedSubviews: views)
  }
}

struct GIVStack: GIStack {
  let view: UIStackView
  
  init(_ views: UIView...) {
    view = UIStackView(arrangedSubviews: views)
    view.axis = .vertical
  }
  
  init(_ views: [UIView]) {
    view = UIStackView(arrangedSubviews: views)
    view.axis = .vertical
  }
}