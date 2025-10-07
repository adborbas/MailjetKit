import Foundation

struct ResponseWrapper: Sendable, Codable {
    let messages: [ResponseMessage]

    private enum CodingKeys: String, CodingKey {
        case messages = "Messages"
    }
}
