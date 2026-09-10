import Foundation

public enum SunPositionCalculator {
	public static func dayProgress(now: Date, sunrise: Date?, sunset: Date?) -> Double? {
		guard let sunrise, let sunset, sunset > sunrise else { return nil }
		guard now >= sunrise, now <= sunset else { return nil }
		return now.timeIntervalSince(sunrise) / sunset.timeIntervalSince(sunrise)
	}
}
