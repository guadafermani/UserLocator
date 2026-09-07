import Testing

@Suite("Project setup")
struct SetupSmokeTests {
    @Test("El target de tests está enlazado y Swift Testing corre")
    func testTargetIsWired() {
        #expect(Bool(true))
    }
}
