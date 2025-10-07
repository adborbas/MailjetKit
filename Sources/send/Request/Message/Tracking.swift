import Foundation

public struct Tracking: Sendable, Equatable, Codable {
    public enum Flag: String, Sendable, Codable {
        case accountDefault = "account_default"
        case disabled
        case enabled
    }
    
    public let customCampaign: String?
    public let deduplicateCampaign: Bool?
    public let trackOpens: Flag?
    public let trackClicks: Flag?
    public let customID: String?
    public let eventPayload: String?
    public let urlTags: String?

    private enum CodingKeys: String, CodingKey {
        case customCampaign = "CustomCampaign"
        case deduplicateCampaign = "DeduplicateCampaign"
        case trackOpens = "TrackOpens"
        case trackClicks = "TrackClicks"
        case customID = "CustomID"
        case eventPayload = "EventPayload"
        case urlTags = "URLTags"
    }

    public init(
        customCampaign: String? = nil,
        deduplicateCampaign: Bool? = nil,
        trackOpens: Flag = .accountDefault,
        trackClicks: Flag = .accountDefault,
        customID: String? = nil,
        eventPayload: String? = nil,
        urlTags: String? = nil
    ) {
        self.customCampaign = customCampaign
        self.deduplicateCampaign = deduplicateCampaign
        self.trackOpens = trackOpens
        self.trackClicks = trackClicks
        self.customID = customID
        self.eventPayload = eventPayload
        self.urlTags = urlTags
    }
}
