import Foundation

public struct Envelope: Sendable, Equatable, Codable {
    public let from: Recipient
    public let sender: Recipient?
    public let to: [Recipient]
    public let cc: [Recipient]?
    public let bcc: [Recipient]?
    public let replyTo: Recipient?

    private enum CodingKeys: String, CodingKey {
        case from = "From"
        case sender = "Sender"
        case to = "To"
        case cc = "Cc"
        case bcc = "Bcc"
        case replyTo = "ReplyTo"
    }
    
    public init(from: Recipient, sender: Recipient? = nil, to: [Recipient], cc: [Recipient]? = nil, bcc: [Recipient]? = nil, replyTo: Recipient? = nil) {
        self.from = from
        self.sender = sender
        self.to = to
        self.cc = cc
        self.bcc = bcc
        self.replyTo = replyTo
    }
}

extension Message {
    public func addTo(_ recipient: Recipient) -> Self {
        var updatedTo = envelope.to
        updatedTo.append(recipient)

        let updatedEnvelope = Envelope(
            from: envelope.from,
            sender: envelope.sender,
            to: updatedTo,
            cc: envelope.cc,
            bcc: envelope.bcc,
            replyTo: envelope.replyTo
        )

        return withUpdatedEnvelope(updatedEnvelope)
    }

    public func addCc(_ recipient: Recipient) -> Self {
        var updatedCc = envelope.cc ?? []
        updatedCc.append(recipient)

        let updatedEnvelope = Envelope(
            from: envelope.from,
            sender: envelope.sender,
            to: envelope.to,
            cc: updatedCc,
            bcc: envelope.bcc,
            replyTo: envelope.replyTo
        )

        return withUpdatedEnvelope(updatedEnvelope)
    }

    public func addBcc(_ recipient: Recipient) -> Self {
        var updatedBcc = envelope.bcc ?? []
        updatedBcc.append(recipient)

        let updatedEnvelope = Envelope(
            from: envelope.from,
            sender: envelope.sender,
            to: envelope.to,
            cc: envelope.cc,
            bcc: updatedBcc,
            replyTo: envelope.replyTo
        )

        return withUpdatedEnvelope(updatedEnvelope)
    }

    public func addReplyTo(_ recipient: Recipient) -> Self {
        let updatedEnvelope = Envelope(
            from: envelope.from,
            sender: envelope.sender,
            to: envelope.to,
            cc: envelope.cc,
            bcc: envelope.bcc,
            replyTo: recipient
        )

        return withUpdatedEnvelope(updatedEnvelope)
    }

    private func withUpdatedEnvelope(_ envelope: Envelope) -> Self {
        Message(
            envelope: envelope,
            content: content,
            template: template,
            tracking: tracking,
            delivery: delivery
        )
    }
}
