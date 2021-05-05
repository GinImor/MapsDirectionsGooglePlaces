//
// ListController.swift
// GILibrary
//
// Created by Gin Imor on 4/19/21.
// Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class GIBaseListController: UICollectionViewController {
  
  init(scrollDirection: UICollectionView.ScrollDirection = .vertical) {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = scrollDirection
    super.init(collectionViewLayout: flowLayout)
  }
  
  override init(collectionViewLayout layout: UICollectionViewLayout) {
    super.init(collectionViewLayout: layout)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

class GIListController<Item>: GIBaseListController {
  
  // MARK: - Properties to Override
  var ItemCellClass: GIListCell<Item>.Type? { nil}
  var HeaderClass: UICollectionReusableView.Type? { nil }
  var FooterClass: UICollectionReusableView.Type? { nil }
  
  // MARK: - Methods to Override
  func setupFlowLayout(_ flowLayout: UICollectionViewFlowLayout) {}
  func configureHeader(_ header: UICollectionReusableView) {}
  func configureFooter(_ footer: UICollectionReusableView) {}
  func additionalSetupForCell(_ cell: GIListCell<Item>, indexPath: IndexPath) {}
  
  var items: [Item] = []
  
  let ItemCellId = "ItemCellId"
  let supplementaryCellId = "supplementaryCellId"
  
  var flowLayout: UICollectionViewFlowLayout {
    collectionView.collectionViewLayout as! UICollectionViewFlowLayout
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  func setupViews() {
    collectionView.backgroundColor = .white
    collectionView.register(ItemCellClass.self, forCellWithReuseIdentifier: ItemCellId)
    collectionView.register(HeaderClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: supplementaryCellId)
    collectionView.register(FooterClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: supplementaryCellId)
    setupFlowLayout(flowLayout)
  }
  
  func setItems(_ items: [Item]) {
    self.items = items
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    items.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
    UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCellId, for: indexPath)
      as! GIListCell<Item>
    cell.item = items[indexPath.item]
    additionalSetupForCell(cell, indexPath: indexPath)
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at
  indexPath: IndexPath) -> UICollectionReusableView {
    let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: supplementaryCellId
      , for: indexPath)
    if kind == UICollectionView.elementKindSectionHeader {
      configureHeader(cell)
    } else if kind == UICollectionView.elementKindSectionFooter {
      configureFooter(cell)
    }
    return cell
  }
  
}
