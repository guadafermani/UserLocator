@testable import UserLocator

extension Address {
    static func fixture(
        street: String? = "Kulas Light",
        suite: String? = "Apt. 556",
        city: String? = "Gwenborough",
        zipcode: String? = "92998-3874"
    ) -> Address {
        Address(street: street, suite: suite, city: city, zipcode: zipcode)
    }
}
