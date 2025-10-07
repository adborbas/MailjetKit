import Foundation

public struct InlineAttachment: Sendable, Equatable, Codable {
    public let fileName: String
    public let contentType: String
    public let base64Content: String
    public let contentID: String

    private enum CodingKeys: String, CodingKey {
        case fileName = "FileName"
        case contentType = "ContentType"
        case base64Content = "Base64Content"
        case contentID = "ContentID"
    }

    public init(fileName: String, contentType: String, base64Content: String, contentID: String) {
        self.fileName = fileName
        self.contentType = contentType
        self.base64Content = base64Content
        self.contentID = contentID
    }
}
