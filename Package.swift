// swift-tools-version:5.5
import PackageDescription
import Foundation

// Absolute paths keep the header settings valid when using --package-path.
let packageDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent().path

// CommerceKit headers also include declarations from StoreFoundation.
let privateFrameworkHeaders: [SwiftSetting] = [
    .unsafeFlags([
        "-Xcc", "-I\(packageDirectory)/Frameworks/CommerceKit",
        "-Xcc", "-I\(packageDirectory)/Frameworks/StoreFoundation",
    ]),
]

let package = Package(
    name: "Latest",
    defaultLocalization: "en",
    platforms: [.macOS("15.6")],
    products: [
        .executable(name: "Latest", targets: ["Latest"]),
    ],
    dependencies: [
        .package(url: "https://github.com/sparkle-project/Sparkle", .exact("2.5.1")),
    ],
    targets: [
        .systemLibrary(name: "CommerceKit", path: "Frameworks/CommerceKit"),
        .systemLibrary(name: "StoreFoundation", path: "Frameworks/StoreFoundation"),
        .executableTarget(
            name: "Latest",
            dependencies: [
                .product(name: "Sparkle", package: "Sparkle"),
                "CommerceKit",
                "StoreFoundation",
            ],
            path: "Latest",
            exclude: [
                "Resources/Info.plist",
                "Resources/Latest.entitlements",
                "Resources/Latest Bridging_Header.h",
                "Utilities/CFBundle_Private.h",
            ],
            resources: [
                .process("Resources"),
            ] + [
                "Base", "ar", "be", "bg", "ca", "cs", "da", "de", "el", "en",
                "es", "et", "fa", "fi", "fil", "fr", "gl", "he", "hi", "hr",
                "hu", "id", "it", "ja", "ko", "ms", "nb", "nl", "pl", "pt",
                "pt-BR", "pt-PT", "ro", "ru", "sk", "sl", "sr", "sv", "th",
                "tr", "uk", "vi", "zh-Hans", "zh-Hant",
            ].map { .process("Interface/\($0).lproj") },
            swiftSettings: privateFrameworkHeaders + [
                // Match the private CoreFoundation declaration used by Xcode.
                .unsafeFlags([
                    "-import-objc-header",
                    "\(packageDirectory)/Latest/Utilities/CFBundle_Private.h",
                ]),
            ],
            linkerSettings: [
                .unsafeFlags(["-F/System/Library/PrivateFrameworks"]),
                .linkedFramework("CommerceKit"),
                .linkedFramework("StoreFoundation"),
            ]
        ),
        .testTarget(
            name: "LatestTests",
            dependencies: ["Latest"],
            path: "Tests",
            exclude: ["Info.plist"],
            swiftSettings: privateFrameworkHeaders
        ),
    ],
    swiftLanguageVersions: [.v5]
)
