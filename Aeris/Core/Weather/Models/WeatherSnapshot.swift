import Foundation

public struct CurrentWeather: Sendable, Codable, Equatable {
	public let temperature: Double
	public let apparentTemperature: Double
	public let condition: WeatherCondition
	public let humidity: Double
	public let windSpeed: Double
	public let windDirection: Double
	public let uvIndex: Int
	public let visibility: Double
	public let pressure: Double
	public let isDaylight: Bool

	public init(temperature: Double, apparentTemperature: Double, condition: WeatherCondition, humidity: Double, windSpeed: Double, windDirection: Double, uvIndex: Int, visibility: Double, pressure: Double, isDaylight: Bool) {
		self.temperature = temperature
		self.apparentTemperature = apparentTemperature
		self.condition = condition
		self.humidity = humidity
		self.windSpeed = windSpeed
		self.windDirection = windDirection
		self.uvIndex = uvIndex
		self.visibility = visibility
		self.pressure = pressure
		self.isDaylight = isDaylight
	}
}

public struct HourForecast: Sendable, Codable, Equatable, Identifiable {
	public var id: Date { date }
	public let date: Date
	public let temperature: Double
	public let condition: WeatherCondition
	public let precipitationChance: Double

	public init(date: Date, temperature: Double, condition: WeatherCondition, precipitationChance: Double) {
		self.date = date
		self.temperature = temperature
		self.condition = condition
		self.precipitationChance = precipitationChance
	}
}

public struct DayForecast: Sendable, Codable, Equatable, Identifiable {
	public var id: Date { date }
	public let date: Date
	public let highTemperature: Double
	public let lowTemperature: Double
	public let condition: WeatherCondition
	public let precipitationChance: Double
	public let sunrise: Date?
	public let sunset: Date?

	public init(date: Date, highTemperature: Double, lowTemperature: Double, condition: WeatherCondition, precipitationChance: Double, sunrise: Date?, sunset: Date?) {
		self.date = date
		self.highTemperature = highTemperature
		self.lowTemperature = lowTemperature
		self.condition = condition
		self.precipitationChance = precipitationChance
		self.sunrise = sunrise
		self.sunset = sunset
	}
}

public struct AirQuality: Sendable, Codable, Equatable {
	public let index: Int
	public let category: String

	public init(index: Int, category: String) {
		self.index = index
		self.category = category
	}
}

public struct WeatherAlert: Sendable, Codable, Equatable, Identifiable {
	public var id: String { summary + (severity ?? "") }
	public let summary: String
	public let severity: String?

	public init(summary: String, severity: String?) {
		self.summary = summary
		self.severity = severity
	}
}

public struct WeatherSnapshot: Sendable, Codable, Equatable {
	public let fetchedAt: Date
	public let coordinate: GeoCoordinate
	public let current: CurrentWeather
	public let hourly: [HourForecast]
	public let daily: [DayForecast]
	public let airQuality: AirQuality?
	public let alerts: [WeatherAlert]

	public init(fetchedAt: Date, coordinate: GeoCoordinate, current: CurrentWeather, hourly: [HourForecast], daily: [DayForecast], airQuality: AirQuality?, alerts: [WeatherAlert]) {
		self.fetchedAt = fetchedAt
		self.coordinate = coordinate
		self.current = current
		self.hourly = hourly
		self.daily = daily
		self.airQuality = airQuality
		self.alerts = alerts
	}

	public func isStale(threshold: TimeInterval) -> Bool {
		Date().timeIntervalSince(fetchedAt) > threshold
	}
}
