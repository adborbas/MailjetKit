import Foundation

public struct ResponseMessage: Sendable, Equatable, Codable {
    public enum Status: String, Sendable, Codable {
        case success
        case error
    }

    public let status: Status
    public let errors: [ResponseError]?
    public let customID: String?
    public let to: [ResponseRecipient]?
    public let cc: [ResponseRecipient]?
    public let bcc: [ResponseRecipient]?

    private enum CodingKeys: String, CodingKey {
        case status = "Status"
        case errors = "Errors"
        case customID = "CustomID"
        case to = "To"
        case cc = "Cc"
        case bcc = "Bcc"
    }
}
