import Alamofire
import Foundation

private struct MailjetMessagesSerializer: DataResponseSerializerProtocol {
    typealias SerializedObject = [ResponseMessage]
    func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> [ResponseMessage] {
        if let error { throw error }
        guard let data else {
            if let status = response?.statusCode { throw MailjetKitError.networkError("HTTP \(status) with empty body") }
            throw MailjetKitError.networkError("No response data")
        }
        if let apiError = try? JSONDecoder().decode(ResponseError.self, from: data) {
            throw MailjetKitError.apiError(apiError)
        }
        if let wrapper = try? JSONDecoder().decode(ResponseWrapper.self, from: data) {
            return wrapper.messages
        }
        let status = response?.statusCode
        let body = String(data: data, encoding: .utf8) ?? "<non-UTF8 body>"
        if let status, !(200...299).contains(status) {
            throw MailjetKitError.networkError("HTTP \(status) – unrecognized body: \(body)")
        }
        throw MailjetKitError.networkError("Unexpected response: \(body)")
    }
}

extension DataRequest {
    func serializingMailjetMessages() -> DataTask<[ResponseMessage]> {
        serializingResponse(using: MailjetMessagesSerializer())
    }
}
