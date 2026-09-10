import Foundation

public enum UnitsFormatter {
	public static func temperature(_ celsius: Double, unit: TemperatureUnit) -> String {
		let value = unit == .celsius ? celsius : celsius * 9 / 5 + 32
		return "\(Int(value.rounded()))\u{00B0}"
	}

	public static func windSpeed(_ kph: Double) -> String {
		"\(Int(kph.rounded())) km/h"
	}

	public static func percentage(_ fraction: Double) -> String {
		"\(Int((fraction * 100).rounded()))%"
	}
}
