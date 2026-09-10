import SwiftUI

public struct WeatherIconView: View {
	public let condition: WeatherCondition
	public let isDaylight: Bool
	@Environment(\.accessibilityReduceMotion) private var reduceMotion
	@State private var animate = false

	public init(condition: WeatherCondition, isDaylight: Bool = true) {
		self.condition = condition
		self.isDaylight = isDaylight
	}

	public var body: some View {
		Image(systemName: condition.sfSymbolName)
			.resizable()
			.aspectRatio(contentMode: .fit)
			.symbolRenderingMode(.multicolor)
			.scaleEffect(animate && !reduceMotion ? 1.05 : 1.0)
			.onAppear {
				guard !reduceMotion else { return }
				withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
					animate = true
				}
			}
			.accessibilityLabel(condition.displayName)
	}
}
