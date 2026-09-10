import SwiftUI

public struct TodayView: View {
	@StateObject private var viewModel: TodayViewModel
	@EnvironmentObject private var settingsStore: SettingsStore

	public init(viewModel: @autoclosure @escaping () -> TodayViewModel) {
		_viewModel = StateObject(wrappedValue: viewModel())
	}

	public var body: some View {
		ZStack {
			WeatherSceneView(
				condition: viewModel.snapshot?.current.condition ?? .clear,
				isDaylight: viewModel.snapshot?.current.isDaylight ?? true
			)

			ScrollView {
				VStack(spacing: 20) {
					if viewModel.isStale {
						Label("Showing cached data" + (viewModel.errorMessage.map { ": \($0)" } ?? ""), systemImage: "exclamationmark.triangle.fill")
							.font(.footnote)
							.padding(8)
							.background(.ultraThinMaterial, in: Capsule())
					}

					if let snapshot = viewModel.snapshot {
						VStack(spacing: 8) {
							WeatherIconView(condition: snapshot.current.condition, isDaylight: snapshot.current.isDaylight)
								.frame(width: 96, height: 96)
							Text(UnitsFormatter.temperature(snapshot.current.temperature, unit: settingsStore.temperatureUnit))
								.font(.system(size: 64, weight: .thin))
							Text(snapshot.current.condition.displayName)
								.font(.title3)
						}

						WindVisualizationView(directionDegrees: snapshot.current.windDirection, speed: snapshot.current.windSpeed)

						ScrollView(.horizontal, showsIndicators: false) {
							HStack(spacing: 16) {
								ForEach(snapshot.hourly.prefix(24)) { hour in
									VStack(spacing: 6) {
										Text(hour.date, format: .dateTime.hour())
											.font(.caption)
										WeatherIconView(condition: hour.condition)
											.frame(width: 28, height: 28)
										Text(UnitsFormatter.temperature(hour.temperature, unit: settingsStore.temperatureUnit))
											.font(.subheadline)
									}
								}
							}
							.padding(.horizontal)
						}

						VStack(spacing: 10) {
							ForEach(snapshot.daily) { day in
								HStack {
									Text(day.date, format: .dateTime.weekday(.abbreviated))
										.frame(width: 50, alignment: .leading)
									WeatherIconView(condition: day.condition)
										.frame(width: 24, height: 24)
									Spacer()
									Text(UnitsFormatter.temperature(day.lowTemperature, unit: settingsStore.temperatureUnit))
										.foregroundStyle(.secondary)
									Text(UnitsFormatter.temperature(day.highTemperature, unit: settingsStore.temperatureUnit))
								}
							}
						}
						.padding()
						.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
						.padding(.horizontal)

						if let aqi = snapshot.airQuality {
							Label("Air Quality Index: \(aqi.index) (\(aqi.category))", systemImage: "aqi.medium")
								.font(.footnote)
								.padding(.horizontal)
						} else {
							Label("Air quality data unavailable", systemImage: "aqi.medium")
								.font(.footnote)
								.foregroundStyle(.secondary)
								.padding(.horizontal)
						}
					} else if let errorMessage = viewModel.errorMessage {
						ContentUnavailableView(errorMessage, systemImage: "exclamationmark.triangle")
					} else if viewModel.isLoading {
						ProgressView()
					}
				}
				.padding(.vertical)
			}
			.refreshable {
				await viewModel.load(forceRefresh: true)
			}
		}
		.task {
			await viewModel.load()
		}
		.foregroundStyle(.white)
	}
}
