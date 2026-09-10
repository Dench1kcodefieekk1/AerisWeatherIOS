import Foundation

public enum WeatherError: Error, Sendable, Equatable, LocalizedError {
	case networkUnavailable
	case locationUnavailable
	case locationPermissionDenied
	case providerUnavailable
	case unknown(String)

	public var isRecoverableWithCache: Bool {
		switch self {
		case .networkUnavailable, .providerUnavailable, .unknown:
			return true
		case .locationUnavailable, .locationPermissionDenied:
			return false
		}
	}

	public var errorDescription: String? {
		switch self {
		case .networkUnavailable: return "No internet connection."
		case .locationUnavailable: return "Your location is unavailable."
		case .locationPermissionDenied: return "Location access is denied."
		case .providerUnavailable: return "Weather data is temporarily unavailable."
		case .unknown(let message): return message
		}
	}
}
