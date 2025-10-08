import Foundation

public struct TemplateOptions: Sendable, Equatable, Codable {
    public let templateID: UInt64
    public let templateLanguage: Bool?
    public let templateErrorReporting: Recipient?
    public let templateErrorDeliver: Bool?
    public let variables: [String: String]?

    private enum CodingKeys: String, CodingKey {
        case templateID = "TemplateID"
        case templateLanguage = "TemplateLanguage"
        case templateErrorReporting = "TemplateErrorReporting"
        case templateErrorDeliver = "TemplateErrorDeliver"
        case variables = "Variables"
    }

    public init(
        templateID: UInt64,
        templateLanguage: Bool? = nil,
        templateErrorReporting: Recipient? = nil,
        templateErrorDeliver: Bool? = nil,
        variables: [String: String]? = nil
    ) {
        self.templateID = templateID
        self.templateLanguage = templateLanguage
        self.templateErrorReporting = templateErrorReporting
        self.templateErrorDeliver = templateErrorDeliver
        self.variables = variables
    }
}
