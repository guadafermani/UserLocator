struct UsersErrorPresentation: Equatable {
    let icon: String
    let titleKey: String
    let messageKey: String
    let noticeKey: String

    init(_ error: UsersError) {
        switch error {
        case .network:
            icon = "wifi.slash"
            titleKey = "user_list.error.network.title"
            messageKey = "user_list.error.network.message"
            noticeKey = "user_list.notice.network"

        case .server:
            icon = "exclamationmark.icloud"
            titleKey = "user_list.error.server.title"
            messageKey = "user_list.error.server.message"
            noticeKey = "user_list.notice.server"

        case .decoding:
            icon = "exclamationmark.triangle"
            titleKey = "user_list.error.decoding.title"
            messageKey = "user_list.error.decoding.message"
            noticeKey = "user_list.notice.decoding"

        case .unknown:
            icon = "questionmark.circle"
            titleKey = "user_list.error.unknown.title"
            messageKey = "user_list.error.unknown.message"
            noticeKey = "user_list.notice.unknown"
        }
    }
}
