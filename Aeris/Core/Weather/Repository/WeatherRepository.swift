import Foundation

public actor WeatherRepository {
	private let provider: any WeatherProvider
	private let cache: WeatherCache
	private var inFlightTasks: [GeoCoordinate: Task<WeatherSnapshot, Error>] = [:]

	public init(provider: any WeatherProvider, cache: WeatherCache = WeatherCache()) {
		self.provider = provider
		self.cache = cache
	}

	public enum FetchResult: Sendable {
		case fresh(WeatherSnapshot)
		case cachedDueToError(WeatherSnapshot, WeatherError)
		case failed(WeatherError)
	}

	public func weather(for coordinate: GeoCoordinate, forceRefresh: Bool = false) async -> FetchResult {
		// WeatherCache is a plain class guarded by an internal queue, so these
		// calls are synchronous -- no `await` needed here.
		if !forceRefresh, let cached = cache.load(for: coordinate), !cached.isStale(threshold: 5 * 60) {
			return .fresh(cached)
		}

		do {
			let snapshot = try await deduplicatedFetch(coordinate: coordinate)
			try? cache.store(snapshot)
			return .fresh(snapshot)
		} catch {
			let weatherError = Self.mapError(error)
			if let cached = cache.load(for: coordinate) {
				return .cachedDueToError(cached, weatherError)
			}
			return .failed(weatherError)
		}
	}

	private func deduplicatedFetch(coordinate: GeoCoordinate) async throws -> WeatherSnapshot {
		if let existing = inFlightTasks[coordinate] {
			return try await existing.value
		}
		let provider = self.provider
		let task = Task { try await provider.fetchSnapshot(for: coordinate) }
		inFlightTasks[coordinate] = task
		defer { inFlightTasks[coordinate] = nil }
		return try await task.value
	}

	private static func mapError(_ error: Error) -> WeatherError {
		if let weatherError = error as? WeatherError { return weatherError }
		let nsError = error as NSError
		if nsError.domain == NSURLErrorDomain { return .networkUnavailable }
		return .unknown(nsError.localizedDescription)
	}
}
