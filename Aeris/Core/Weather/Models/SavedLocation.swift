import Foundation

public struct SavedLocation: Sendable, Codable, Identifiable, Hashable {
	public let id: UUID
	public var name: String
	public var coordinate: GeoCoordinate
	public var isCurrentLocation: Bool

	public init(id: UUID = UUID(), name: String, coordinate: GeoCoordinate, isCurrentLocation: Bool = false) {
		self.id = id
		self.name = name
		self.coordinate = coordinate
		self.isCurrentLocation = isCurrentLocation
	}

	public static func == (lhs: SavedLocation, rhs: SavedLocation) -> Bool {
		lhs.id == rhs.id
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
