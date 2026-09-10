import Foundation

@MainActor
public final class TodayViewModel: ObservableObject {
	@Published public private(set) var snapshot: WeatherSnapshot?
	@Published public private(set) var isStale = false
	@Published public private(set) var errorMessage: String?
	@Published public private(set) var isLoading = false

	private let repository: WeatherRepository
	private let coordinate: GeoCoordinate

	public init(repository: WeatherRepository, coordinate: GeoCoordinate) {
		self.repository = repository
		self.coordinate = coordinate
	}

	public func load(forceRefresh: Bool = false) async {
		isLoading = true
		defer { isLoading = false }
		let result = await repository.weather(for: coordinate, forceRefresh: forceRefresh)
		switch result {
		case .fresh(let snapshot):
			self.snapshot = snapshot
			self.isStale = false
			self.errorMessage = nil
		case .cachedDueToError(let snapshot, let error):
			self.snapshot = snapshot
			self.isStale = true
			self.errorMessage = error.errorDescription
		case .failed(let error):
			self.errorMessage = error.errorDescription
		}
	}
}
