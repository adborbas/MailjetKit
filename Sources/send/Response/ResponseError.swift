import Foundation

public struct ResponseError: Sendable, Equatable, Codable {
    public let identifier: String
    public let code: String
    public let statusCode: Int
    public let message: String
    public let relatedTo: [String]

    private enum CodingKeys: String, CodingKey {
        case identifier = "ErrorIdentifier"
        case code = "ErrorCode"
        case statusCode = "StatusCode"
        case message = "ErrorMessage"
        case relatedTo = "ErrorRelatedTo"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
        code = try container.decode(String.self, forKey: .code)
        statusCode = try container.decode(Int.self, forKey: .statusCode)
        message = try container.decode(String.self, forKey: .message)

        if let many = try? container.decode([String].self, forKey: .relatedTo) {
            relatedTo = many
        } else if let single = try? container.decode(String.self, forKey: .relatedTo) {
            relatedTo = [single]
        } else {
            relatedTo = []
        }
    }
    
    init(identifier: String, code: String, statusCode: Int, message: String, relatedTo: [String]) {
        self.identifier = identifier
        self.code = code
        self.statusCode = statusCode
        self.message = message
        self.relatedTo = relatedTo
    }
}
