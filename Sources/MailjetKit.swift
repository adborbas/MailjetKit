import Foundation
import Alamofire

public enum MailjetKitError: Error {
    case networkError(String)
    case unknownError(Error?)
    case apiError(ResponseError)
}

public class MailjetKit {
    private static let requestURL = "https://api.mailjet.com/v3.1/send"
    
    private let apiKey: String
    private let apiSecret: String
    private let session: Session
    
    public convenience init(apiKey: String, apiSecret: String) {
        self.init(apiKey: apiKey, apiSecret: apiSecret, session: Session())
    }
    
    init(apiKey: String, apiSecret: String, session: Session) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
        self.session = session
    }
    
    public func send(message: Message) async -> Result<ResponseMessage, MailjetKitError> {
        let request = MailjetKitRequest(messages: [message])
        let result = await send(request: request)
        switch result {
        case .success(let response):
            return .success(response.first!)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func send(request: MailjetKitRequest) async -> Result<[ResponseMessage], MailjetKitError> {
        let response = await session
            .request(
                Self.requestURL,
                method: .post,
                parameters: request,
                encoder: JSONParameterEncoder.default
            )
            .authenticate(username: apiKey, password: apiSecret)
            .serializingMailjetMessages()
            .response
        
        switch response.result {
        case .success(let messages):
            return .success(messages)
        case .failure(let error):
            if let apiError = error.underlyingError as? MailjetKitError {
                return .failure(apiError)
            }
            return .failure(.unknownError(error.underlyingError))
        }
    }
}
