import Foundation
import Mocker

enum MockResponse: String {
    case mixedSuccessError
    case successWithErrors
    case apiError

    var resourcePath: URL {
        guard let url = Bundle.module.url(
            forResource: rawValue,
            withExtension: "json",
            subdirectory: "Resources"
        ) else {
            fatalError("Missing test resource: \(rawValue).json in Resources/")
        }
        return url
    }

    static var nonSpecificSamplesFolder: URL {
        if let dir = Bundle.module.url(
            forResource: "NonSpecifcSamples",
            withExtension: nil,
            subdirectory: "Resources"
        ) {
            return dir
        }
        fatalError("Missing directory resource: Resources/NonSpecifcSamples")
    }
}

extension Mock {
    init(url: URL, response: MockResponse) {
        self.init(
            url: url,
            contentType: .json,
            statusCode: 200,
            data: [
                .post: try! Data(contentsOf: response.resourcePath)
            ]
        )
    }

    init(url: URL, fileURL: URL) {
        self.init(
            url: url,
            contentType: .json,
            statusCode: 200,
            data: [
                .post: try! Data(contentsOf: fileURL)
            ]
        )
    }
}

extension Bundle {
    static var test: Bundle { Bundle.module }
}
