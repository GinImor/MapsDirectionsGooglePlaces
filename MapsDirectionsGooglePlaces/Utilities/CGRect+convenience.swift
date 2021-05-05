//
// CGRect+convenience.swift
// GILibrary
//
// Created by Gin Imor on 5/3/21.
// Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

extension CGRect {
  var values: [CGFloat] {[minX, minY, width, height]}
}