import Foundation

@MainActor
public final class SettingsStore: ObservableObject {
	@Published public var temperatureUnit: TemperatureUnit {
		didSet { defaults.set(temperatureUnit.rawValue, forKey: unitKey) }
	}
	@Published public var reduceMotionOverride: Bool {
		didSet { defaults.set(reduceMotionOverride, forKey: motionKey) }
	}

	private let defaults: UserDefaults
	private let unitKey = "com.aeris.temperatureUnit"
	private let motionKey = "com.aeris.reduceMotionOverride"

	public init(defaults: UserDefaults = .standard) {
		self.defaults = defaults
		if let raw = defaults.string(forKey: unitKey), let unit = TemperatureUnit(rawValue: raw) {
			temperatureUnit = unit
		} else {
			temperatureUnit = Locale.current.measurementSystem == .metric ? .celsius : .fahrenheit
		}
		reduceMotionOverride = defaults.bool(forKey: motionKey)
	}
}
