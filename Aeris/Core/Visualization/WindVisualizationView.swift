import SwiftUI

public struct WindVisualizationView: View {
	public let directionDegrees: Double
	public let speed: Double
	@Environment(\.accessibilityReduceMotion) private var reduceMotion
	@State private var pulse = false

	public init(directionDegrees: Double, speed: Double) {
		self.directionDegrees = directionDegrees
		self.speed = speed
	}

	public var body: some View {
		VStack(spacing: 8) {
			Image(systemName: "location.north.fill")
				.rotationEffect(.degrees(directionDegrees))
				.scaleEffect(pulse && !reduceMotion ? 1.1 : 1.0)
				.onAppear {
					guard !reduceMotion else { return }
					withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
						pulse = true
					}
				}
			Text(UnitsFormatter.windSpeed(speed))
				.font(.headline)
		}
	}
}
