import XCTest
@testable import Aeris

final class WeatherRepositoryTests: XCTestCase {
	func testFreshFetchReturnsSnapshot() async {
		let repository = WeatherRepository(provider: MockWeatherProvider(), cache: WeatherCache(directoryURL: FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)))
		let coordinate = GeoCoordinate(latitude: 10, longitude: 10)
		let result = await repository.weather(for: coordinate)
		switch result {
		case .fresh(let snapshot):
			XCTAssertEqual(snapshot.coordinate, coordinate)
		default:
			XCTFail("Expected fresh result")
		}
	}

	func testConditionDisplayNameIsNotEmpty() {
		for condition in WeatherCondition.allCases {
			XCTAssertFalse(condition.displayName.isEmpty)
		}
	}

	func testSunPositionCalculatorOutsideRangeReturnsNil() {
		let now = Date()
		let sunrise = now.addingTimeInterval(3600)
		let sunset = now.addingTimeInterval(7200)
		XCTAssertNil(SunPositionCalculator.dayProgress(now: now, sunrise: sunrise, sunset: sunset))
	}
}
