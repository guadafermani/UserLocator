import Testing
@testable import UserLocator

@Suite("InitialsFormatter")
struct InitialsFormatterTests {

    @Test(arguments: [
        ("Leanne Graham", "LG"),
        ("Ervin Howell", "EH"),
        ("Clementine Bauch", "CB"),
        ("Patricia Lebsack", "PL"),
        ("Chelsey Dietrich", "CD"),
        ("Kurtis Weissnat", "KW"),
        ("Glenna Reichert", "GR"),
        ("Clementina DuBuque", "CD")
    ])
    func whenNameHasTwoOrMoreWords_takesTheFirstLetterOfEachOfTheFirstTwo(
        name: String,
        expected: String
    ) {
        #expect(InitialsFormatter.initials(from: name) == expected)
    }

    @Test(arguments: ["Mrs. Dennis Schulist", "mrs Dennis Schulist", "Dr. Dennis Schulist"])
    func whenNameHasATitle_dropsIt(name: String) {
        #expect(InitialsFormatter.initials(from: name) == "DS")
    }

    @Test(arguments: ["Nicholas Runolfsdottir V", "Nicholas Runolfsdottir Jr.", "Nicholas Runolfsdottir PhD"])
    func whenNameHasASuffix_dropsIt(name: String) {
        #expect(InitialsFormatter.initials(from: name) == "NR")
    }

    @Test
    func whenNameIsASingleWord_takesItsFirstTwoLetters() {
        #expect(InitialsFormatter.initials(from: "Cher") == "Ch")
    }

    @Test
    func whenNameIsASingleLetter_returnsThatLetter() {
        #expect(InitialsFormatter.initials(from: "V") == "V")
    }

    @Test
    func whenNameHasExtraWhitespace_ignoresIt() {
        #expect(InitialsFormatter.initials(from: "  Leanne   Graham  ") == "LG")
    }

    @Test
    func whenFilteringLeavesNoWords_fallsBackToTheRawName() {
        #expect(InitialsFormatter.initials(from: "Dr.") == "Dr")
    }

    @Test
    func whenNameHasAccents_preservesThem() {
        #expect(InitialsFormatter.initials(from: "Ángela Ríos") == "ÁR")
    }

    @Test(arguments: ["", "   "])
    func whenNameIsBlank_returnsNil(name: String) {
        #expect(InitialsFormatter.initials(from: name) == nil)
    }
}
