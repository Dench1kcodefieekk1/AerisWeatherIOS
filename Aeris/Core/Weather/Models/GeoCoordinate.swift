import Foundation

public struct GeoCoordinate: Hashable, Sendable, Codable, Equatable {
	public let latitude: Double
	public let longitude: Double

	public init(latitude: Double, longitude: Double) {
		self.latitude = latitude
		self.longitude = longitude
	}

	public static func == (lhs: GeoCoordinate, rhs: GeoCoordinate) -> Bool {
		lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
	}
}
