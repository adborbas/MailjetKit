import Foundation

public struct ResponseRecipient: Sendable, Equatable, Codable {
    public let email: String
    public let messageUUID: String
    public let messageID: UInt64
    public let messageHref: String

    private enum CodingKeys: String, CodingKey {
        case email = "Email"
        case messageUUID = "MessageUUID"
        case messageID = "MessageID"
        case messageHref = "MessageHref"
    }
}
