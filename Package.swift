// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "MailjetKit",
    platforms: [
        .iOS(.v16), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6)
    ],
    products: [
        .library(name: "MailjetKit", targets: ["MailjetKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.10.2")),
        .package(url: "https://github.com/WeTransfer/Mocker.git", .upToNextMajor(from: "3.0.0")),
    ],
    targets: [
        .target(
            name: "MailjetKit",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "MailjetKitTests",
            dependencies: ["MailjetKit", "Mocker"],
            path: "Tests",
            resources: [ .copy("Resources")],
        )
    ]
)
