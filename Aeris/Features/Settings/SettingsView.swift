import SwiftUI

public struct SettingsView: View {
	@EnvironmentObject private var settingsStore: SettingsStore

	public init() {}

	public var body: some View {
		Form {
			Section("Units") {
				Picker("Temperature", selection: $settingsStore.temperatureUnit) {
					Text("Celsius").tag(TemperatureUnit.celsius)
					Text("Fahrenheit").tag(TemperatureUnit.fahrenheit)
				}
			}
			Section("Accessibility") {
				Toggle("Always Reduce Motion", isOn: $settingsStore.reduceMotionOverride)
			}
			Section("About") {
				Label("Air quality is never fabricated — shown only when a real data source provides it.", systemImage: "checkmark.seal")
					.font(.footnote)
					.foregroundStyle(.secondary)
			}
		}
		.navigationTitle("Settings")
	}
}
