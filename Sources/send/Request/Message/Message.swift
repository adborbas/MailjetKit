import Foundation

public struct Message: Sendable, Equatable, Codable {
    public let envelope: Envelope
    public let content: Content
    public let template: TemplateOptions
    public let tracking: Tracking
    public let delivery: DeliveryOptions
    
    public init(
        envelope: Envelope,
        content: Content,
        template: TemplateOptions = TemplateOptions(),
        tracking: Tracking = Tracking(),
        delivery: DeliveryOptions = DeliveryOptions()
    ) {
        self.envelope = envelope
        self.content = content
        self.template = template
        self.tracking = tracking
        self.delivery = delivery
    }
    
    public func encode(to encoder: Encoder) throws {
        try envelope.encode(to: encoder)
        try content.encode(to: encoder)
        try template.encode(to: encoder)
        try tracking.encode(to: encoder)
        try delivery.encode(to: encoder)
    }
    
    public init(from decoder: Decoder) throws {
        self.envelope = try Envelope(from: decoder)
        self.content  = try Content(from: decoder)
        
        self.template = try TemplateOptions(from: decoder)
        self.tracking = try Tracking(from: decoder)
        self.delivery = try DeliveryOptions(from: decoder)
    }
    
    public init(from: Recipient, to: Recipient, subject: String, textPart: String) {
        self.init(
            envelope: Envelope(from: from, to: [to]),
            content: Content(subject: subject, textPart: textPart),
            template: TemplateOptions(),
            tracking: Tracking(),
            delivery: DeliveryOptions()
        )
    }
    
    public init(from: Recipient, to: Recipient, subject: String, htmlPart: String) {
        self.init(
            envelope: Envelope(from: from, to: [to]),
            content: Content(subject: subject, htmlPart: htmlPart),
            template: TemplateOptions(),
            tracking: Tracking(),
            delivery: DeliveryOptions()
        )
    }
}
