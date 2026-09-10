import SwiftUI

public struct DetailsView: View {
	public let snapshot: WeatherSnapshot

	public init(snapshot: WeatherSnapshot) {
		self.snapshot = snapshot
	}

	public var body: some View {
		List {
			Section("Sun") {
				if let today = snapshot.daily.first {
					if let sunrise = today.sunrise {
						LabeledContent("Sunrise", value: sunrise.formatted(date: .omitted, time: .shortened))
					}
					if let sunset = today.sunset {
						LabeledContent("Sunset", value: sunset.formatted(date: .omitted, time: .shortened))
					}
					if let progress = SunPositionCalculator.dayProgress(now: .now, sunrise: today.sunrise, sunset: today.sunset) {
						ProgressView(value: progress)
					}
				}
			}
			Section("Air Quality") {
				if let aqi = snapshot.airQuality {
					LabeledContent("Index", value: "\(aqi.index)")
					LabeledContent("Category", value: aqi.category)
				} else {
					Text("Air quality data unavailable for this location.")
						.foregroundStyle(.secondary)
				}
			}
			if !snapshot.alerts.isEmpty {
				Section("Alerts") {
					ForEach(snapshot.alerts) { alert in
						Text(alert.summary)
					}
				}
			}
		}
		.navigationTitle("Details")
	}
}
