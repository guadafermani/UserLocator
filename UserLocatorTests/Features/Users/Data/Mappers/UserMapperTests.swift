import Testing
@testable import UserLocator

@Suite("UserMapper")
struct UserMapperTests {

    @Test
    func whenMappingDTO_producesEntityWithSameValues() {
        let dto = UserDTO(id: 7, name: "Kurtis Weissnat", username: "Elwyn.Skiles")

        let user = UserMapper.map(dto)

        #expect(user == User(id: 7, name: "Kurtis Weissnat", username: "Elwyn.Skiles"))
    }

    @Test
    func whenMappingEmptyList_returnsEmptyList() {
        #expect(UserMapper.map([]).isEmpty)
    }
}
