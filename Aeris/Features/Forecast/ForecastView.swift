import SwiftUI

public struct ForecastView: View {
	public let snapshot: WeatherSnapshot?
	@EnvironmentObject private var settingsStore: SettingsStore

	public init(snapshot: WeatherSnapshot?) {
		self.snapshot = snapshot
	}

	public var body: some View {
		List {
			if let snapshot {
				Section("Hourly") {
					ForEach(snapshot.hourly.prefix(24)) { hour in
						HStack {
							Text(hour.date, format: .dateTime.hour())
							Spacer()
							WeatherIconView(condition: hour.condition).frame(width: 20, height: 20)
							Text(UnitsFormatter.temperature(hour.temperature, unit: settingsStore.temperatureUnit))
						}
					}
				}
				Section("Daily") {
					ForEach(snapshot.daily) { day in
						HStack {
							Text(day.date, format: .dateTime.weekday(.wide))
							Spacer()
							WeatherIconView(condition: day.condition).frame(width: 20, height: 20)
							Text(UnitsFormatter.temperature(day.lowTemperature, unit: settingsStore.temperatureUnit))
								.foregroundStyle(.secondary)
							Text(UnitsFormatter.temperature(day.highTemperature, unit: settingsStore.temperatureUnit))
						}
					}
				}
			} else {
				ContentUnavailableView("No forecast yet", systemImage: "cloud")
			}
		}
		.navigationTitle("Forecast")
	}
}
