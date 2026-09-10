import Foundation

public protocol WeatherProvider: Sendable {
	func fetchSnapshot(for coordinate: GeoCoordinate) async throws -> WeatherSnapshot
}
