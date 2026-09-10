import Foundation

public struct MockWeatherProvider: WeatherProvider {
	public init() {}

	public func fetchSnapshot(for coordinate: GeoCoordinate) async throws -> WeatherSnapshot {
		let now = Date()
		let current = CurrentWeather(
			temperature: 18,
			apparentTemperature: 17,
			condition: .partlyCloudy,
			humidity: 0.55,
			windSpeed: 12,
			windDirection: 220,
			uvIndex: 4,
			visibility: 10000,
			pressure: 1015,
			isDaylight: true
		)
		let hourly = (0..<24).map { offset -> HourForecast in
			HourForecast(
				date: now.addingTimeInterval(TimeInterval(offset * 3600)),
				temperature: 18 - Double(offset % 6),
				condition: offset % 5 == 0 ? .rain : .partlyCloudy,
				precipitationChance: offset % 5 == 0 ? 0.6 : 0.1
			)
		}
		let daily = (0..<7).map { offset -> DayForecast in
			DayForecast(
				date: Calendar.current.date(byAdding: .day, value: offset, to: now) ?? now,
				highTemperature: 20 - Double(offset),
				lowTemperature: 12 - Double(offset),
				condition: .partlyCloudy,
				precipitationChance: 0.2,
				sunrise: Calendar.current.date(bySettingHour: 6, minute: 30, second: 0, of: now),
				sunset: Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: now)
			)
		}
		return WeatherSnapshot(
			fetchedAt: now,
			coordinate: coordinate,
			current: current,
			hourly: hourly,
			daily: daily,
			airQuality: AirQuality(index: 42, category: "Good"),
			alerts: []
		)
	}
}
