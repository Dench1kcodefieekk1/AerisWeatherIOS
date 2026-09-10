import Foundation

@MainActor
public final class LocationsStore: ObservableObject {
	@Published public private(set) var locations: [SavedLocation] = []
	private let defaults: UserDefaults
	private let key = "com.aeris.savedLocations"

	public init(defaults: UserDefaults = .standard) {
		self.defaults = defaults
		load()
	}

	public func add(_ location: SavedLocation) {
		guard !locations.contains(where: { $0.coordinate == location.coordinate }) else { return }
		locations.append(location)
		persist()
	}

	public func remove(_ location: SavedLocation) {
		locations.removeAll { $0.id == location.id }
		persist()
	}

	private func load() {
		guard let data = defaults.data(forKey: key),
			let decoded = try? JSONDecoder().decode([SavedLocation].self, from: data) else { return }
		locations = decoded
	}

	private func persist() {
		guard let data = try? JSONEncoder().encode(locations) else { return }
		defaults.set(data, forKey: key)
	}
}
