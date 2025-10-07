import Foundation

public struct Content: Sendable, Equatable, Codable {
    public let subject: String?
    public let textPart: String?
    public let htmlPart: String?
    public let attachments: [Attachment]?
    public let inlinedAttachments: [InlineAttachment]?

    private enum CodingKeys: String, CodingKey {
        case subject = "Subject"
        case textPart = "TextPart"
        case htmlPart = "HTMLPart"
        case attachments = "Attachments"
        case inlinedAttachments = "InlinedAttachments"
    }
    
    public init(subject: String? = nil, textPart: String? = nil, htmlPart: String? = nil, attachments: [Attachment]? = nil, inlinedAttachments: [InlineAttachment]? = nil) {
        self.subject = subject
        self.textPart = textPart
        self.htmlPart = htmlPart
        self.attachments = attachments
        self.inlinedAttachments = inlinedAttachments
    }
}

extension Message {
    public func addAttachment(_ attachment: Attachment) -> Self {
        var updatedAttachments = content.attachments ?? []
        updatedAttachments.append(attachment)

        let updatedContent = Content(
            subject: content.subject,
            textPart: content.textPart,
            htmlPart: content.htmlPart,
            attachments: updatedAttachments,
            inlinedAttachments: content.inlinedAttachments
        )
        
        return withUpdatedContent(updatedContent)
    }
    
    public func addInlineAttachment(_ inlineAttachment: InlineAttachment) -> Self {
        var updatedAttachments = content.inlinedAttachments ?? []
        updatedAttachments.append(inlineAttachment)

        let updatedContent = Content(
            subject: content.subject,
            textPart: content.textPart,
            htmlPart: content.htmlPart,
            attachments: content.attachments,
            inlinedAttachments: updatedAttachments
        )

        return withUpdatedContent(updatedContent)
    }
    
    private func withUpdatedContent(_ content: Content) -> Self {
        Message(
            envelope: envelope,
            content: content,
            template: template,
            tracking: tracking,
            delivery: delivery
        )
    }
}
