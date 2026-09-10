import SwiftUI

public struct RootView: View {
	@EnvironmentObject private var locationsStore: LocationsStore
	private let repository: WeatherRepository

	public init(repository: WeatherRepository) {
		self.repository = repository
	}

	public var body: some View {
		TabView {
			NavigationStack {
				TodayView(viewModel: TodayViewModel(repository: repository, coordinate: currentCoordinate))
			}
			.tabItem { Label("Today", systemImage: "sun.max.fill") }

			NavigationStack {
				WeatherMapView(locations: locationsStore.locations)
			}
			.tabItem { Label("Map", systemImage: "map.fill") }

			NavigationStack {
				LocationsView()
			}
			.tabItem { Label("Locations", systemImage: "list.bullet") }

			NavigationStack {
				SettingsView()
			}
			.tabItem { Label("Settings", systemImage: "gearshape.fill") }
		}
	}

	private var currentCoordinate: GeoCoordinate {
		locationsStore.locations.first?.coordinate ?? GeoCoordinate(latitude: 37.3349, longitude: -122.0090)
	}
}
