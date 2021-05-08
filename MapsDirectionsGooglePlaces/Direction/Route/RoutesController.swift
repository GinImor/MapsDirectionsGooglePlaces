//
//  RoutesController.swift
//  MapsDirectionsGooglePlaces
//
//  Created by Gin Imor on 5/8/21.
//  
//

import UIKit
import MapKit

extension CLLocationDistance {
  
  var milesString: String {
    String(format: "%.2f mi", self * 0.00062137)
  }
}

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
    distanceLabel.text = item.distance.milesString
  }
}

class RoutesController: GIListController<MKRoute.Step>, UICollectionViewDelegateFlowLayout {
  
  override var ItemCellClass: GIListCell<MKRoute.Step>.Type? { RouteCell.self }
  override var HeaderClass: UICollectionReusableView.Type? { RouteHeader.self }
  
  var route: MKRoute! {
    didSet { setItems(route.steps) }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.bounds.width, height: 70)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: 0, height: 120)
  }
  
  override func configureHeader(_ header: UICollectionReusableView) {
    guard let header = header as? RouteHeader else { return }
    header.configureViewWith(route: route)
  }
}
