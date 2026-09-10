import SwiftUI

public struct WeatherSceneView: View {
	public let condition: WeatherCondition
	public let isDaylight: Bool
	@Environment(\.accessibilityReduceMotion) private var reduceMotion
	@State private var animate = false

	public init(condition: WeatherCondition, isDaylight: Bool) {
		self.condition = condition
		self.isDaylight = isDaylight
	}

	private var palette: [Color] {
		if !isDaylight {
			return [Color(red: 0.03, green: 0.05, blue: 0.16), Color(red: 0.1, green: 0.12, blue: 0.28)]
		}
		switch condition {
		case .clear, .mostlyClear:
			return [Color(red: 0.25, green: 0.55, blue: 0.95), Color(red: 0.55, green: 0.78, blue: 0.98)]
		case .rain, .heavyRain, .drizzle, .thunderstorms:
			return [Color(red: 0.22, green: 0.27, blue: 0.34), Color(red: 0.38, green: 0.44, blue: 0.5)]
		case .snow, .heavySnow, .flurries, .blizzard, .blowingSnow, .sleet:
			return [Color(red: 0.68, green: 0.75, blue: 0.85), Color(red: 0.85, green: 0.9, blue: 0.96)]
		default:
			return [Color(red: 0.45, green: 0.55, blue: 0.65), Color(red: 0.65, green: 0.72, blue: 0.78)]
		}
	}

	public var body: some View {
		LinearGradient(colors: palette, startPoint: animate ? .topLeading : .bottomTrailing, endPoint: animate ? .bottomTrailing : .topLeading)
			.ignoresSafeArea()
			.onAppear {
				guard !reduceMotion else { return }
				withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
					animate = true
				}
			}
	}
}
