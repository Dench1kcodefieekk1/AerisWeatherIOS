import SwiftUI

public struct LocationsView: View {
	@EnvironmentObject private var locationsStore: LocationsStore

	public init() {}

	public var body: some View {
		List {
			ForEach(locationsStore.locations) { location in
				VStack(alignment: .leading) {
					Text(location.name).font(.headline)
					Text("\(location.coordinate.latitude, specifier: "%.2f"), \(location.coordinate.longitude, specifier: "%.2f")")
						.font(.caption)
						.foregroundStyle(.secondary)
				}
			}
			.onDelete { indices in
				for index in indices {
					locationsStore.remove(locationsStore.locations[index])
				}
			}
		}
		.navigationTitle("Locations")
		.overlay {
			if locationsStore.locations.isEmpty {
				ContentUnavailableView("No saved locations", systemImage: "mappin.slash")
			}
		}
	}
}
