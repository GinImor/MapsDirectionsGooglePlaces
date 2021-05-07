//
//  LocationSearchController.swift
//  MapsDirectionsGooglePlaces
//
//  Created by Gin Imor on 5/7/21.
//  
//

import SwiftUI
import UIKit
import MapKit
import Combine

class LocationSearchCell: GIListCell<MKMapItem> {
  
  let nameLabel = UILabel.new("Name", .headline)
  let addressLabel = UILabel.new("Address", .footnote)
  
  override func setup() {
    super.setup()
    GIVStack(nameLabel, addressLabel).spacing()
      .add(to: self).filling(self, edgeInsets: .init(0, 16, 8))
    addBottomBorder(leftPad: 16)
  }
  
  override func didSetItem() {
    nameLabel.text = item.name
    addressLabel.text = item.address
  }
}

class LocationSearchController: GIListController<MKMapItem>, UICollectionViewDelegateFlowLayout {
  
  override var ItemCellClass: GIListCell<MKMapItem>.Type? {
    LocationSearchCell.self
  }
  
  var didSelectMapItem: ((MKMapItem) -> Void)?
  
  let backButton = UIButton.system(imageName: "arrow.left", size: 18, tintColor: .black)
  let searchTextField = IndentedTextField(8, "Enter search term", .body)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupListeners()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    textFiledListener?.cancel()
  }
  
  private var textFiledListener: AnyCancellable?
  
  private func setupListeners() {
    backButton.addTarget(self, action: #selector(handleBack))
    textFiledListener = NotificationCenter.default
      .publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .sink(receiveValue: { [weak self] (_) in
        self?.performLocalSearch()
      })
  }
  
  @objc func handleBack() {
    navigationController?.popViewController(animated: true)
  }
  
  override func setupViews() {
    super.setupViews()
    searchTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
    searchTextField.layer.borderWidth = 2
    searchTextField.layer.borderColor = UIColor.red.cgColor
    searchTextField.layer.cornerRadius = 8
    
    let navBar = UIView(backgroundColor: .white)
    navBar.add(to: view).hLining(.horizontal, to: view)
      .vLining(.top, to: view).vLining(.bottom, .top, value: navBarHeight)
    GIHStack(backButton, searchTextField.withCH(249, axis: .horizontal)).spacing()
      .add(to: navBar).filling(edgeInsets: .init(0, 16, 8))
    
    collectionView.verticalScrollIndicatorInsets.top += navBarHeight
  }
  
  private let navBarHeight: CGFloat = 55
  
  override func setupFlowLayout(_ flowLayout: UICollectionViewFlowLayout) {
    flowLayout.sectionInset.top = navBarHeight
  }
  
  private func performLocalSearch() {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = searchTextField.text
    let localSearch = MKLocalSearch(request: request)
    localSearch.start { [weak self] (response, error) in
      if let error = error {
        print("local search error in direction controller", error)
        return
      }
      guard let response = response else { return }
      self?.setItems(response.mapItems)
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    navigationController?.popViewController(animated: true)
    didSelectMapItem?(items[indexPath.item])
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.bounds.width, height: 70)
  }
}


struct LocationSearchView: UIViewControllerRepresentable {
  
  func makeUIViewController(context: Context) -> some UIViewController {
    return LocationSearchController()
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
  }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
      LocationSearchView().edgesIgnoringSafeArea(.all)
    }
}
