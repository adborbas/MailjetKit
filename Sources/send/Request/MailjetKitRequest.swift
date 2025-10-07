import Foundation

public struct MailjetKitRequest: Sendable, Codable {
    public let sandboxMode: Bool?
    public let advanceErrorHandling: Bool?
    public let globals: [String: String]?
    public let messages: [Message]

    private enum CodingKeys: String, CodingKey {
        case sandboxMode = "SandboxMode"
        case advanceErrorHandling = "AdvanceErrorHandling"
        case globals = "Globals"
        case messages = "Messages"
    }

    public init(
        sandboxMode: Bool? = nil,
        advanceErrorHandling: Bool? = nil,
        globals: [String: String]? = nil,
        messages: [Message]
    ) {
        self.sandboxMode = sandboxMode
        self.advanceErrorHandling = advanceErrorHandling
        self.globals = globals
        self.messages = messages
    }
}
