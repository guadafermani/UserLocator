import Testing
@testable import UserLocator

@Suite("UsersErrorPresentation")
struct UsersErrorPresentationTests {

    @Test(arguments: [
        (UsersError.network, "wifi.slash"),
        (UsersError.server, "exclamationmark.icloud"),
        (UsersError.decoding, "exclamationmark.triangle"),
        (UsersError.unknown, "questionmark.circle")
    ])
    func whenBuildingThePresentation_usesTheIconOfTheError(error: UsersError, expected: String) {
        let sut = UsersErrorPresentation(error)

        #expect(sut.icon == expected)
    }

    @Test(arguments: [
        (UsersError.network, "user_list.error.network.title"),
        (UsersError.server, "user_list.error.server.title"),
        (UsersError.decoding, "user_list.error.decoding.title"),
        (UsersError.unknown, "user_list.error.unknown.title")
    ])
    func whenBuildingThePresentation_usesTheTitleOfTheError(error: UsersError, expected: String) {
        let sut = UsersErrorPresentation(error)

        #expect(sut.titleKey == expected)
    }

    @Test(arguments: [
        (UsersError.network, "user_list.error.network.message"),
        (UsersError.server, "user_list.error.server.message"),
        (UsersError.decoding, "user_list.error.decoding.message"),
        (UsersError.unknown, "user_list.error.unknown.message")
    ])
    func whenBuildingThePresentation_usesTheMessageOfTheError(error: UsersError, expected: String) {
        let sut = UsersErrorPresentation(error)

        #expect(sut.messageKey == expected)
    }

    @Test(arguments: [
        (UsersError.network, "user_list.notice.network"),
        (UsersError.server, "user_list.notice.server"),
        (UsersError.decoding, "user_list.notice.decoding"),
        (UsersError.unknown, "user_list.notice.unknown")
    ])
    func whenBuildingThePresentation_usesTheNoticeTextOfTheError(error: UsersError, expected: String) {
        let sut = UsersErrorPresentation(error)

        #expect(sut.noticeKey == expected)
    }
}
