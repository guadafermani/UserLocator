import Testing
@testable import UserLocator

@Suite("AppConfiguration")
struct AppConfigurationTests {

    @Test
    func whenKeyIsUsable_keepsIt() {
        let sut = AppConfiguration(googleMapsAPIKey: "AIzaSyExampleKeyValue")

        #expect(sut.googleMapsAPIKey == "AIzaSyExampleKeyValue")
    }

    @Test
    func whenKeyHasSurroundingWhitespace_trimsIt() {
        let sut = AppConfiguration(googleMapsAPIKey: "  AIzaSyExampleKeyValue\n")

        #expect(sut.googleMapsAPIKey == "AIzaSyExampleKeyValue")
    }

    @Test(arguments: [nil, "", "   ", "TU_API_KEY_DE_GOOGLE_MAPS_ACA"])
    func whenKeyIsNotUsable_isNil(key: String?) {
        let sut = AppConfiguration(googleMapsAPIKey: key)

        #expect(sut.googleMapsAPIKey == nil)
    }
}
