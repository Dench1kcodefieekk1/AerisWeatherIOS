import Foundation
#if canImport(UIKit)
import UIKit

@MainActor
public enum HapticsService {
	public static func lightTap() {
		UIImpactFeedbackGenerator(style: .light).impactOccurred()
	}

	public static func selectionChanged() {
		UISelectionFeedbackGenerator().selectionChanged()
	}
}
#else
@MainActor
public enum HapticsService {
	public static func lightTap() {}
	public static func selectionChanged() {}
}
#endif
