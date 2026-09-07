import GoogleMaps

struct GoogleMapsActivator {
    func activate(apiKey: String?) -> Bool {
        guard let apiKey else { return false }

        return GMSServices.provideAPIKey(apiKey)
    }
}
