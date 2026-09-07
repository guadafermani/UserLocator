import Foundation

struct AppConfiguration: Sendable {
    static let googleMapsAPIKeyInfoKey = "GMSApiKey"

    private static let googleMapsAPIKeyPlaceholder = "TU_API_KEY_DE_GOOGLE_MAPS_ACA"

    let googleMapsAPIKey: String?

    init(googleMapsAPIKey: String?) {
        let trimmed = googleMapsAPIKey?.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let trimmed, !trimmed.isEmpty, trimmed != Self.googleMapsAPIKeyPlaceholder else {
            self.googleMapsAPIKey = nil
            return
        }
        self.googleMapsAPIKey = trimmed
    }
}
