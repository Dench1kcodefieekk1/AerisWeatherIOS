import Foundation
#if canImport(WeatherKit)
import WeatherKit
import CoreLocation

public struct WeatherKitProvider: WeatherProvider {
	private let service = WeatherService.shared

	public init() {}

	public func fetchSnapshot(for coordinate: GeoCoordinate) async throws -> WeatherSnapshot {
		let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
		let weather = try await service.weather(for: location)

		let currentModel = CurrentWeather(
			temperature: weather.currentWeather.temperature.value,
			apparentTemperature: weather.currentWeather.apparentTemperature.value,
			condition: Self.mapCondition(weather.currentWeather.condition),
			humidity: weather.currentWeather.humidity,
			windSpeed: weather.currentWeather.wind.speed.value,
			windDirection: weather.currentWeather.wind.direction.value,
			uvIndex: weather.currentWeather.uvIndex.value,
			visibility: weather.currentWeather.visibility.value,
			pressure: weather.currentWeather.pressure.value,
			isDaylight: weather.currentWeather.isDaylight
		)

		let hourly = weather.hourlyForecast.forecast.prefix(48).map { hour in
			HourForecast(
				date: hour.date,
				temperature: hour.temperature.value,
				condition: Self.mapCondition(hour.condition),
				precipitationChance: hour.precipitationChance
			)
		}

		let daily = weather.dailyForecast.forecast.prefix(10).map { day in
			DayForecast(
				date: day.date,
				highTemperature: day.highTemperature.value,
				lowTemperature: day.lowTemperature.value,
				condition: Self.mapCondition(day.condition),
				precipitationChance: day.precipitationChance,
				sunrise: day.sun.sunrise,
				sunset: day.sun.sunset
			)
		}

		// Air quality is intentionally omitted: WeatherKit does not expose a
		// public air-quality API on all platforms. We never fabricate this
		// value; it stays nil unless a real data source is wired in.
		let aqi: AirQuality? = nil

		return WeatherSnapshot(
			fetchedAt: .now,
			coordinate: coordinate,
			current: currentModel,
			hourly: Array(hourly),
			daily: Array(daily),
			airQuality: aqi,
			alerts: []
		)
	}

	// NOTE: WeatherKit.WeatherCondition is not a frozen/exhaustive enum from
	// Apple's perspective, so this switch always ends with a `default` case
	// to stay resilient to future SDK additions. Only case names verified
	// against the current WeatherKit SDK are referenced explicitly below.
	static func mapCondition(_ condition: WeatherKit.WeatherCondition) -> WeatherCondition {
		switch condition {
		case .clear: return .clear
		case .mostlyClear: return .mostlyClear
		case .partlyCloudy: return .partlyCloudy
		case .mostlyCloudy, .cloudy: return .cloudy
		case .drizzle: return .drizzle
		case .rain: return .rain
		case .heavyRain: return .heavyRain
		case .freezingRain, .freezingDrizzle: return .freezingRain
		case .snow: return .snow
		case .heavySnow: return .heavySnow
		case .flurries: return .flurries
		case .sleet, .wintryMix: return .sleet
		case .thunderstorms, .isolatedThunderstorms, .scatteredThunderstorms, .strongStorms: return .thunderstorms
		case .hail: return .hail
		case .windy: return .windy
		case .breezy: return .breezy
		case .hurricane: return .hurricane
		case .tropicalStorm: return .tropicalStorm
		case .blizzard: return .blizzard
		case .blowingSnow: return .blowingSnow
		case .smoky: return .smoky
		case .foggy: return .foggy
		case .haze: return .haze
		default: return .partlyCloudy
		}
	}
}
#endif
