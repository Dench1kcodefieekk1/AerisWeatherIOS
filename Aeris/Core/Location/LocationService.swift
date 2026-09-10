import Foundation
import CoreLocation

@MainActor
public final class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
	private let manager = CLLocationManager()
	@Published public private(set) var authorizationStatus: CLAuthorizationStatus
	@Published public private(set) var currentCoordinate: GeoCoordinate?
	private var continuation: CheckedContinuation<GeoCoordinate, Error>?

	public override init() {
		authorizationStatus = manager.authorizationStatus
		super.init()
		manager.delegate = self
		manager.desiredAccuracy = kCLLocationAccuracyKilometer
	}

	public func requestAuthorization() {
		manager.requestWhenInUseAuthorization()
	}

	public func requestCurrentLocation() async throws -> GeoCoordinate {
		try await withCheckedThrowingContinuation { continuation in
			self.continuation = continuation
			manager.requestLocation()
		}
	}

	public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		authorizationStatus = manager.authorizationStatus
	}

	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		let coordinate = GeoCoordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
		currentCoordinate = coordinate
		continuation?.resume(returning: coordinate)
		continuation = nil
	}

	public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		continuation?.resume(throwing: error)
		continuation = nil
	}
}
