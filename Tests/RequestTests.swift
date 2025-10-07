import Testing
import Foundation

@testable import MailjetKit
import struct MailjetKit.Attachment

struct RequestTests {
    
    @Test
    private func requestContainsAllFieldsFlattened() throws {
        // Envelope
        let envelope = Envelope(
            from: Recipient(email: "from@example.com", name: "From Name"),
            sender: Recipient(email: "sender@example.com", name: "Sender Name"),
            to: [
                Recipient(email: "to1@example.com", name: "To One"),
                Recipient(email: "to2@example.com", name: "To Two")
            ],
            cc: [Recipient(email: "cc@example.com", name: "CC Guy")],
            bcc: [Recipient(email: "bcc@example.com", name: "BCC Gal")],
            replyTo: Recipient(email: "reply@example.com", name: "Reply Guy")
        )

        // Content
        let attachments: [Attachment] = [
            Attachment(fileName: "file.txt", contentType: "text/plain", base64Content: "SGVsbG8=")
        ]
        let inlined: [InlineAttachment] = [
            InlineAttachment(fileName: "logo.png", contentType: "image/png", base64Content: "iVBORw0KGgo=", contentID: "logo_cid")
        ]
        let content = Content(
            subject: "All Fields",
            textPart: "Plain text",
            htmlPart: "<p>HTML</p>",
            attachments: attachments,
            inlinedAttachments: inlined
        )

        // Template
        let template = TemplateOptions(
            templateID: 123456,
            templateLanguage: true,
            templateErrorReporting: Recipient(email: "errors@example.com", name: "Errors"),
            templateErrorDeliver: true,
            variables: ["name": "Ada", "product": "MailjetKit"]
        )

        // Tracking
        let tracking = Tracking(
            customCampaign: "launch-1",
            deduplicateCampaign: true,
            trackOpens: .enabled,
            trackClicks: .disabled,
            customID: "custom-123",
            eventPayload: "{\"foo\":\"bar\"}",
            urlTags: "utm_source=test&utm_medium=ci"
        )

        // Delivery
        let delivery = DeliveryOptions(
            priority: 5,
            headers: ["X-Custom": "Value", "X-Env": "CI"]
        )

        let message = Message(
            envelope: envelope,
            content: content,
            template: template,
            tracking: tracking,
            delivery: delivery
        )

        let data = try JSONEncoder().encode(message)
        let json = try #require(String(data: data, encoding: .utf8))

        #expect(json.contains("from@example.com"))
        #expect(json.contains("sender@example.com"))
        #expect(json.contains("to1@example.com"))
        #expect(json.contains("cc@example.com"))
        #expect(json.contains("bcc@example.com"))
        #expect(json.contains("reply@example.com"))
        #expect(json.contains("All Fields"))
        #expect(json.contains("Plain text"))
        #expect(json.contains("HTML"))
        #expect(json.contains("file.txt"))
        #expect(json.contains("logo.png"))
        #expect(json.contains("logo_cid"))
        #expect(json.contains("launch-1"))
        #expect(json.contains("custom-123"))
        #expect(json.contains("utm_source=test"))
        #expect(json.contains("X-Custom"))

        for key in [
            "\"From\"","\"Sender\"","\"To\"","\"Cc\"","\"Bcc\"","\"ReplyTo\"",
            "\"Subject\"","\"TextPart\"","\"HTMLPart\"","\"Attachments\"","\"InlinedAttachments\"",
            "\"TemplateID\"","\"TemplateLanguage\"","\"TemplateErrorReporting\"","\"TemplateErrorDeliver\"","\"Variables\"",
            "\"CustomCampaign\"","\"DeduplicateCampaign\"","\"TrackOpens\"","\"TrackClicks\"","\"CustomID\"","\"EventPayload\"","\"URLTags\"",
            "\"Priority\"","\"Headers\""
        ] {
            #expect(json.contains(key))
        }

        #expect(!json.contains("Envelope"))
        #expect(!json.contains("TemplateOptions"))
        #expect(!json.contains("Tracking"))
        #expect(!json.contains("DeliveryOptions"))
    }
    
    @Test
    private func requestDoesNotContainComposeValues() throws {
        let request = Message(from: Recipient(email: "nice@email.com"), to: Recipient(email: "pleasesend@email.com"), subject: "Subject", textPart: "Nice email bro")
        
        let rawJson = try JSONEncoder().encode(request)
        let jsonString = String(data: rawJson, encoding: .utf8)
        
        #expect(jsonString != nil)
        let result = try #require(jsonString)
        #expect(result.contains("nice@email.com"))
        #expect(!result.contains("Envelop"))
        #expect(!result.contains("Content"))
        #expect(!result.contains("Tracking"))
        #expect(!result.contains("DeliveryOptions"))
    }
    
    
}
