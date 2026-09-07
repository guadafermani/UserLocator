import SwiftUI
import UIKit

enum AppTypography {
    static let rowTitle = Font.system(.body, weight: .semibold)
    static let rowSubtitle = Font.system(.subheadline)
    static let avatarInitials = Font.system(.subheadline, weight: .semibold)
    static let cardTitle = Font.system(.title3, weight: .semibold)
    static let cardSubtitle = Font.system(.body, weight: .medium)
    static let cardDetail = Font.system(.subheadline)
    static let message = Font.system(.body)
    static let stateTitle = Font.system(.title3, weight: .semibold)
    static let stateIcon = Font.system(.largeTitle)
    static let notice = Font.system(.footnote)
    static let disclosure = Font.system(.footnote, weight: .semibold)
    static let mapControlIcon = Font.system(size: 20, weight: .semibold)
    static let markerInitials = UIFont.systemFont(ofSize: 13, weight: .semibold)
}
