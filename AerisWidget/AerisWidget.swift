import WidgetKit
import SwiftUI

struct WeatherEntry: TimelineEntry {
	let date: Date
	let snapshot: WeatherSnapshot?
}

struct WeatherTimelineProvider: TimelineProvider {
	func placeholder(in context: Context) -> WeatherEntry {
		WeatherEntry(date: .now, snapshot: nil)
	}

	func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> Void) {
		Task {
			let snapshot = try? await MockWeatherProvider().fetchSnapshot(for: GeoCoordinate(latitude: 37.3349, longitude: -122.0090))
			completion(WeatherEntry(date: .now, snapshot: snapshot))
		}
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {
		Task {
			let cache = WeatherCache()
			let coordinate = GeoCoordinate(latitude: 37.3349, longitude: -122.0090)
			var snapshot = cache.load(for: coordinate)
			if snapshot == nil {
				snapshot = try? await MockWeatherProvider().fetchSnapshot(for: coordinate)
			}
			let entry = WeatherEntry(date: .now, snapshot: snapshot)
			let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: .now) ?? .now
			completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
		}
	}
}

struct AerisWidgetEntryView: View {
	var entry: WeatherEntry

	var body: some View {
		if let snapshot = entry.snapshot {
			VStack(alignment: .leading, spacing: 4) {
				WeatherIconView(condition: snapshot.current.condition, isDaylight: snapshot.current.isDaylight)
					.frame(width: 32, height: 32)
				Text(UnitsFormatter.temperature(snapshot.current.temperature, unit: .celsius))
					.font(.title2)
				Text(snapshot.current.condition.displayName)
					.font(.caption)
			}
			.padding()
		} else {
			Text("Weather unavailable")
				.font(.caption)
				.padding()
		}
	}
}

@main
struct AerisWidget: Widget {
	let kind: String = "AerisWidget"

	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: WeatherTimelineProvider()) { entry in
			AerisWidgetEntryView(entry: entry)
		}
		.configurationDisplayName("Aeris Weather")
		.description("Shows current conditions for your saved location.")
		.supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
	}
}
