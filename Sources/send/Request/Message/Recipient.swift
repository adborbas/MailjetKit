import Foundation

public struct Recipient: Sendable, Equatable, Codable {
    public let email: String
    public let name: String?

    private enum CodingKeys: String, CodingKey {
        case email = "Email"
        case name = "Name"
    }

    public init(email: String, name: String? = nil) {
        self.email = email
        self.name = name
    }
}
