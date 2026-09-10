import Foundation

public enum WeatherCondition: String, Sendable, Codable, CaseIterable {
	case clear, mostlyClear, partlyCloudy, cloudy, foggy, haze
	case drizzle, rain, heavyRain, freezingRain
	case snow, heavySnow, flurries, sleet
	case thunderstorms, hail, windy, hurricane, tropicalStorm
	case blizzard, blowingSnow, smoky, breezy

	public var sfSymbolName: String {
		switch self {
		case .clear: return "sun.max.fill"
		case .mostlyClear: return "sun.max"
		case .partlyCloudy: return "cloud.sun.fill"
		case .cloudy: return "cloud.fill"
		case .foggy, .haze, .smoky: return "cloud.fog.fill"
		case .drizzle: return "cloud.drizzle.fill"
		case .rain: return "cloud.rain.fill"
		case .heavyRain: return "cloud.heavyrain.fill"
		case .freezingRain, .sleet: return "cloud.sleet.fill"
		case .snow: return "cloud.snow.fill"
		case .heavySnow, .blizzard, .blowingSnow: return "wind.snow"
		case .flurries: return "snowflake"
		case .thunderstorms: return "cloud.bolt.rain.fill"
		case .hail: return "cloud.hail.fill"
		case .windy, .breezy: return "wind"
		case .hurricane, .tropicalStorm: return "hurricane"
		}
	}

	public var displayName: String {
		switch self {
		case .clear: return "Clear"
		case .mostlyClear: return "Mostly Clear"
		case .partlyCloudy: return "Partly Cloudy"
		case .cloudy: return "Cloudy"
		case .foggy: return "Foggy"
		case .haze: return "Haze"
		case .drizzle: return "Drizzle"
		case .rain: return "Rain"
		case .heavyRain: return "Heavy Rain"
		case .freezingRain: return "Freezing Rain"
		case .snow: return "Snow"
		case .heavySnow: return "Heavy Snow"
		case .flurries: return "Flurries"
		case .sleet: return "Sleet"
		case .thunderstorms: return "Thunderstorms"
		case .hail: return "Hail"
		case .windy: return "Windy"
		case .hurricane: return "Hurricane"
		case .tropicalStorm: return "Tropical Storm"
		case .blizzard: return "Blizzard"
		case .blowingSnow: return "Blowing Snow"
		case .smoky: return "Smoky"
		case .breezy: return "Breezy"
		}
	}

	public var isPrecipitating: Bool {
		switch self {
		case .drizzle, .rain, .heavyRain, .freezingRain, .snow, .heavySnow, .flurries, .sleet, .thunderstorms, .hail, .blizzard, .blowingSnow:
			return true
		default:
			return false
		}
	}
}
