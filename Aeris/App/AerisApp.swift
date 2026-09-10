import SwiftUI

@main
struct AerisApp: App {
	@StateObject private var locationsStore = LocationsStore()
	@StateObject private var settingsStore = SettingsStore()
	private let repository: WeatherRepository

	init() {
		let provider: any WeatherProvider
		#if canImport(WeatherKit)
		provider = WeatherKitProvider()
		#else
		provider = MockWeatherProvider()
		#endif
		repository = WeatherRepository(provider: provider)
	}

	var body: some Scene {
		WindowGroup {
			RootView(repository: repository)
				.environmentObject(locationsStore)
				.environmentObject(settingsStore)
		}
	}
}
