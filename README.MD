# MailjetKit

A Swift package for sending emails through the [Mailjet API](https://dev.mailjet.com/email/guides/send-api-V3-1/).  
Currently supports the `/send` endpoint (v3.1).

## Overview

**MailjetKit** is a lightweight, type-safe Swift SDK for sending emails using Mailjet’s REST API.

This package is ideal for server-side Swift (e.g. Vapor, Hummingbird, SwiftNIO apps), command-line tools, or macOS/iOS utilities that need to send transactional or templated emails.

## Features

- Fully asynchronous (using Swift Concurrency)
- Type-safe Mailjet `/send` v3.1 endpoint
- Strongly typed `Message`, `Envelope`, `Content`, and `Attachment` models
- Immutable builder-style API (`addAttachment`, `addTo`, `addHeader`, etc.)

## Installation

### Swift Package Manager

Add **MailjetKit** to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/adborbas/MailjetKit.git", from: "0.1.0")
]
```

Then add `"MailjetKit"` as a dependency to your target:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "MailjetKit", package: "MailjetKit")
    ]
)
```

## Usage and Examples

💡 Before using MailjetKit, you’ll need a Mailjet account and API credentials.
You can [sign up for a Mailjet account](https://app.mailjet.com/signup) and then [create an API key](https://app.mailjet.com/account/apikeys) from your account dashboard.

### Create a Mailjet client

```swift
import MailjetKit

let mailjet = MailjetKit(
    apiKey: "YOUR_API_KEY",
    apiSecret: "YOUR_API_SECRET"
)
```

### Send a simple email

```swift
let message = Message(
    from: Recipient(email: "noreply@yourdomain.com", name: "Your App"),
    to: Recipient(email: "user@example.com", name: "Test User"),
    subject: "Welcome to MailjetKit!",
    textPart: "Hello there! This is a plain text email from MailjetKit."
)

let response = await mailjet.send(message: message)
switch response {
case .success(let value):
    print("Message sent: \(value.status)")
case .failure(let error):
    print("Error sending email: \(error)")
}
```

### Send an HTML email with attachments

```swift
let htmlMessage = Message(
    from: Recipient(email: "noreply@yourdomain.com"),
    to: Recipient(email: "user@example.com"),
    subject: "Hello, HTML!",
    htmlPart: "<h1>Hello</h1><p>This is an <strong>HTML</strong> message.</p>"
)
.addAttachment(
    Attachment(
        contentType: "text/plain",
        filename: "example.txt",
        base64Content: Data("Hello world!".utf8).base64EncodedString()
    )
)

let response = await mailjet.send(message: htmlMessage)
switch response {
case .success(let value):
    print("✅ Sent successfully: \(value)")
case .failure(let error):
    print("❌ Failed: \(error)")
}
```

### Using a templated email

```swift
let templatedMessage = Message(
    envelope: Envelope(
        from: Recipient(email: "noreply@yourdomain.com"),
        to: [Recipient(email: "customer@example.com")]
    ),
    template: TemplateOptions(
        templateID: 123456,
        templateLanguage: true,
        variables: [
            "name": "Jane Doe",
            "product": "MailjetKit"
        ]
    )
)

await mailjet.send(message: templatedMessage)
```
