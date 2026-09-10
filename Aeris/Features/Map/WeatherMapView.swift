import SwiftUI
import MapKit

public struct WeatherMapView: View {
	public let locations: [SavedLocation]
	@State private var cameraPosition: MapCameraPosition

	public init(locations: [SavedLocation]) {
		self.locations = locations
		let center = locations.first?.coordinate ?? GeoCoordinate(latitude: 37.3349, longitude: -122.0090)
		_cameraPosition = State(initialValue: .region(
			MKCoordinateRegion(
				center: CLLocationCoordinate2D(latitude: center.latitude, longitude: center.longitude),
				span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
			)
		))
	}

	public var body: some View {
		Map(position: $cameraPosition) {
			ForEach(locations) { location in
				Marker(location.name, coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
			}
		}
		.navigationTitle("Map")
	}
}
