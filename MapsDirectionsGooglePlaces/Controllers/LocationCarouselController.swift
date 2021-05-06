//
// LocationCarouselController.swift
// MapsDirectionsGooglePlaces
//
// Created by Gin Imor on 5/6/21.
// 
//

import UIKit
import MapKit

protocol LocationCarouselControllerDelegate: class {
  func didSelectItem(_ mapItem: MKMapItem)
}

class LocationCarouselController: GIListController<MKMapItem>, UICollectionViewDelegateFlowLayout {
  
  weak var delegate: LocationCarouselControllerDelegate?
  
  override var ItemCellClass: GIListCell<MKMapItem>.Type? {
    LocationCarouselCell.self
  }
  
  override func setupViews() {
    super.setupViews()
    collectionView.backgroundColor = .clear
    collectionView.clipsToBounds = false
  }
  
  override func setupFlowLayout(_ flowLayout: UICollectionViewFlowLayout) {
    flowLayout.sectionInset = .init(vertical: 0, horizontal: 16)
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    delegate?.didSelectItem(items[indexPath.item])
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.bounds.width - 64, height: view.bounds.height)
  }
}
