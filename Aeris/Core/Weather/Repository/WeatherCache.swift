import Foundation

public final class WeatherCache: @unchecked Sendable {
	private let queue = DispatchQueue(label: "com.aeris.weathercache")
	private let directoryURL: URL

	public init(directoryURL: URL? = nil) {
		if let directoryURL {
			self.directoryURL = directoryURL
		} else {
			let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
				?? FileManager.default.temporaryDirectory
			self.directoryURL = base.appendingPathComponent("AerisWeatherCache", isDirectory: true)
		}
		try? FileManager.default.createDirectory(at: self.directoryURL, withIntermediateDirectories: true)
	}

	private func fileURL(for coordinate: GeoCoordinate) -> URL {
		let key = String(format: "%.4f_%.4f", coordinate.latitude, coordinate.longitude)
		return directoryURL.appendingPathComponent("\(key).json")
	}

	public func load(for coordinate: GeoCoordinate) -> WeatherSnapshot? {
		queue.sync {
			let url = fileURL(for: coordinate)
			guard let data = try? Data(contentsOf: url) else { return nil }
			return try? JSONDecoder().decode(WeatherSnapshot.self, from: data)
		}
	}

	public func store(_ snapshot: WeatherSnapshot) throws {
		try queue.sync {
			let url = fileURL(for: snapshot.coordinate)
			let data = try JSONEncoder().encode(snapshot)
			try data.write(to: url, options: .atomic)
		}
	}
}
