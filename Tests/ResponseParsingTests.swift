import Testing
import Foundation
import Alamofire
import Mocker

@testable import MailjetKit

struct ResponseParsingTests {
    
    @Test
    private func canParseMixedSuccessAndErrorResponse() async throws {
        // Given
        let mailjet = givenMailjetKit()
        given(response: .mixedSuccessError)
        
        // When
        let response = await expectResponse(for: MailjetKitRequest.any, on: mailjet)
        
        // Then
        let expectedResponse: [ResponseMessage] = [
            ResponseMessage(status: .error,
                            errors: [
                                ResponseError(identifier: "88b5ca9f-5f1f-42e7-a45e-9ecbad0c285e",
                                              code: "send-0003",
                                              statusCode: 400,
                                              message: "At least \"HTMLPart\", \"TextPart\" or \"TemplateID\" must be provided.",
                                              relatedTo: ["HTMLPart", "TextPart"])],
                            customID: nil,
                            to: nil,
                            cc: nil,
                            bcc: nil),
            
            ResponseMessage(status: .success,
                            errors: nil,
                            customID: "",
                            to: [
                                ResponseRecipient(email: "passenger2@mailjet.com",
                                                  messageUUID: "cb927469-36fd-4c02-bce4-0d199929a207",
                                                  messageID: 70650219165027410,
                                                  messageHref: "https://api.mailjet.com/v3/REST/message/70650219165027410")],
                            cc: [],
                            bcc: [])
            
        ]
        #expect(response == expectedResponse)
    }
    
    @Test
    private func canParseSuccessWithError() async throws {
        // Given
        let mailjet = givenMailjetKit()
        given(response: .successWithErrors)
        
        // When
        let response = await expectResponse(for: MailjetKitRequest.any, on: mailjet)
        
        // Then
        #expect(response.count == 1)
        #expect(response[0].status == .success)
        #expect(response[0].errors!.count == 1)
    }
    
    @Test
    private func canParseFromTheNonSpecificSamplesFolder() async throws  {
        let mailjet = givenMailjetKit()
        let samples = try FileManager.default.contentsOfDirectory(
            at: MockResponse.nonSpecificSamplesFolder,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )
        for sample in samples {
            Mock(url: URL(string: "https://api.mailjet.com/v3.1/send")!, fileURL: sample).register()
            let response = await expectResponse(for: MailjetKitRequest.any, on: mailjet)
            #expect(!response.isEmpty)
        }
    }
    
    @Test
    private func canaParseApiError() async throws {
        // Given
        let mailjet = givenMailjetKit()
        given(response: .apiError)
        
        // When
        let error = await expectError(for: MailjetKitRequest.any, on: mailjet)
        
        // Then
        #expect(error != nil)
    }
    
    private func givenMailjetKit() -> MailjetKit {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let sessionManager = Alamofire.Session(configuration: configuration)
        return MailjetKit(apiKey: "", apiSecret: "", session: sessionManager)
    }
    
    private func given(response: MockResponse) {
        Mock(url: URL(string: "https://api.mailjet.com/v3.1/send")!, response: response).register()
    }
    
    private func expectResponse(for request: MailjetKitRequest, on mailjet: MailjetKit) async -> [ResponseMessage] {
        let result = await mailjet.send(request: MailjetKitRequest.any)
        switch result {
        case .success(let messages):
            return messages
        case .failure(let error):
            Issue.record(error, "Expecte success but got an error.")
            return []
        }
    }
    
    private func expectError(for request: MailjetKitRequest, on mailjet: MailjetKit) async -> MailjetKitError? {
        let result = await mailjet.send(request: MailjetKitRequest.any)
        switch result {
        case .success:
            Issue.record("Expecte error but got messages.")
            return nil
        case .failure(let error):
            return error
        }
    }
}

extension MailjetKitRequest {
    static var any: MailjetKitRequest {
        return MailjetKitRequest(messages: [Message.any])
    }
}

extension Message {
    static var any: Message {
        return Message(from: Recipient(email: ""), to: Recipient(email: ""), subject: "", textPart: "")
    }
}

extension Recipient {
    static var any: Recipient {
        return Recipient(email: "user@domain.com")
    }
}
