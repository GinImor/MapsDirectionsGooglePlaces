//
//  RoutesController.swift
//  MapsDirectionsGooglePlaces
//
//  Created by Gin Imor on 5/8/21.
//  
//

import UIKit
import MapKit

class RouteCell: GIListCell<MKRoute.Step> {
  
  let instructionsLabel = UILabel.new("instruction", .subheadline, 0)
  let distanceLabel = UILabel.new("0.00 mi", .caption1)
  
  override func setup() {
    super.setup()
    GIHStack(instructionsLabel, distanceLabel.withCH(999, axis: .horizontal))
      .spacing().add(to: self).filling(edgeInsets: .init(16))
    addBottomBorder(leadingAnchor: instructionsLabel.leadingAnchor)
  }
  
  override func didSetItem() {
    instructionsLabel.text = item.instructions
    let mile = item.distance * 0.00062137
    distanceLabel.text = String(format: "%.2f mi", mile)
  }
}

class RoutesController: GIListController<MKRoute.Step>, UICollectionViewDelegateFlowLayout {
  
  override var ItemCellClass: GIListCell<MKRoute.Step>.Type? { RouteCell.self }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.bounds.width, height: 70)
  }
}
