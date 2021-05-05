//
// ListCell.swift
// GILibrary
//
// Created by Gin Imor on 4/19/21.
// Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class GIListCell<Item>: UICollectionViewCell {
  
  // MARK: - Methods to Override
  func didSetItem() {}
  func setup() {
    backgroundColor = .white
  }
  
  var item: Item! {
    didSet { didSetItem() }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
