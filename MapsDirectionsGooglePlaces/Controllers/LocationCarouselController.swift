//
// LocationCarouselController.swift
// MapsDirectionsGooglePlaces
//
// Created by Gin Imor on 5/6/21.
// 
//

import UIKit

class LocationCarouselController: GIListController<UIColor>, UICollectionViewDelegateFlowLayout {
  
  override var ItemCellClass: GIListCell<UIColor>.Type? {
    LocationCarouselCell.self
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fetchData()
  }
  
  private func fetchData() {
    items = [.red, .blue, .brown]
  }
  
  override func setupViews() {
    super.setupViews()
    collectionView.backgroundColor = .clear
    collectionView.clipsToBounds = false
  }
  
  override func setupFlowLayout(_ flowLayout: UICollectionViewFlowLayout) {
    flowLayout.sectionInset = .init(vertical: 0, horizontal: 16)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.bounds.width - 64, height: view.bounds.height)
  }
}
