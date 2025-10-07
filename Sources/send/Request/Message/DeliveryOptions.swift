import Foundation

public struct DeliveryOptions: Sendable, Equatable, Codable {
    public let priority: Int?
    public let headers: [String: String]?

    private enum CodingKeys: String, CodingKey {
        case priority = "Priority"
        case headers = "Headers"
    }

    public init(priority: Int? = nil, headers: [String: String]? = nil) {
        self.priority = priority
        self.headers = headers
    }
}

extension Message {
    public func addHeader(_ name: String, _ value: String) -> Self {
        var merged = delivery.headers ?? [:]
        merged[name] = value

        let updatedDelivery = DeliveryOptions(
            priority: delivery.priority,
            headers: merged
        )

        return withUpdatedDelivery(updatedDelivery)
    }

    public func addHeaders(_ newHeaders: [String: String]) -> Self {
        var merged = delivery.headers ?? [:]
        for (k, v) in newHeaders { merged[k] = v }

        let updatedDelivery = DeliveryOptions(
            priority: delivery.priority,
            headers: merged
        )

        return withUpdatedDelivery(updatedDelivery)
    }

    public func withPriority(_ priority: Int?) -> Self {
        let updatedDelivery = DeliveryOptions(
            priority: priority,
            headers: delivery.headers
        )

        return withUpdatedDelivery(updatedDelivery)
    }

    private func withUpdatedDelivery(_ delivery: DeliveryOptions) -> Self {
        Message(
            envelope: envelope,
            content: content,
            template: template,
            tracking: tracking,
            delivery: delivery
        )
    }
}
