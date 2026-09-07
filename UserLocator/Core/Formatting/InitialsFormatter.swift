enum InitialsFormatter {
    private static let titles: Set<String> = ["mr", "mrs", "ms", "miss", "dr", "prof"]
    private static let suffixes: Set<String> = ["jr", "sr", "ii", "iii", "iv", "v", "md", "dds", "phd"]

    static func initials(from name: String) -> String? {
        let words = name.split(whereSeparator: \.isWhitespace).map(String.init)
        return initials(fromWords: dropTitleAndSuffix(from: words)) ?? initials(fromWords: words)
    }

    private static func dropTitleAndSuffix(from words: [String]) -> [String] {
        var remaining = words
        if let first = remaining.first, titles.contains(comparable(first)) {
            remaining.removeFirst()
        }
        if let last = remaining.last, suffixes.contains(comparable(last)) {
            remaining.removeLast()
        }
        return remaining
    }

    private static func comparable(_ word: String) -> String {
        word.lowercased().filter { $0 != "." }
    }

    private static func initials(fromWords words: [String]) -> String? {
        guard let firstWord = words.first, let firstLetter = firstWord.first else { return nil }

        if let secondWord = words.dropFirst().first, let secondLetter = secondWord.first {
            return String(firstLetter).uppercased() + String(secondLetter).uppercased()
        }

        guard let secondLetter = firstWord.dropFirst().first else {
            return String(firstLetter).uppercased()
        }
        return String(firstLetter).uppercased() + String(secondLetter)
    }
}
