//
// MKMapItem+address.swift
// MapsDirectionsGooglePlaces
//
// Created by Gin Imor on 5/5/21.
// 
//

import MapKit

extension MKMapItem {
  
  var address: String {
    var addressString = ""
    if placemark.subThoroughfare != nil {
      addressString = placemark.subThoroughfare! + " "
    }
    if placemark.thoroughfare != nil {
      addressString += placemark.thoroughfare! + ", "
    }
    if placemark.postalCode != nil {
      addressString += placemark.postalCode! + " "
    }
    if placemark.locality != nil {
      addressString += placemark.locality! + ", "
    }
    if placemark.administrativeArea != nil {
      addressString += placemark.administrativeArea! + " "
    }
    if placemark.country != nil {
      addressString += placemark.country!
    }
    return addressString
  }
}