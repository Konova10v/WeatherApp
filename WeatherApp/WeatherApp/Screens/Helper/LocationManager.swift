//
//  LocationManager.swift
//  Weather
//
//  Created by Кирилл Коновалов on 26.05.2025.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
	private let manager = CLLocationManager()

	@Published var location: CLLocation?
	@Published var authorizationStatus: CLAuthorizationStatus?

	override init() {
		super.init()
		manager.delegate = self
		manager.desiredAccuracy = kCLLocationAccuracyKilometer
		manager.requestWhenInUseAuthorization()
		manager.startUpdatingLocation()
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		location = locations.first
	}

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		authorizationStatus = status
		if status == .authorizedWhenInUse || status == .authorizedAlways {
			manager.startUpdatingLocation()
		}
	}
}
