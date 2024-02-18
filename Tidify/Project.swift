import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

private enum Layer: CaseIterable {
  case core
  case domain
  case data
  case presentation

  var layerName: String {
    switch self {
    case .core: return "TidifyCore"
    case .domain: return "TidifyDomain"
    case .data: return "TidifyData"
    case .presentation: return "TidifyPresentation"
    }
  }
}

private let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "14.0", devices: [.iphone])

// MARK: - Project

func makeTidifyFrameworkTargets(
  name: String,
  platform: Platform,
  dependencies: [TargetDependency]) -> [Target] {

    let sources = Target(
      name: name,
      platform: platform,
      product: .framework,
      bundleId: "com.ian.\(name)",
      deploymentTarget: deploymentTarget,
      infoPlist: .default,
      sources: ["Targets/\(name)/Sources/**"],
      resources: [],
      entitlements: "./Tidify.entitlements",
      dependencies: dependencies,
      settings: .settings(base: .init()
        .swiftCompilationMode(.wholemodule))
    )

    let tests = Target(
      name: "\(name)Tests",
      platform: platform,
      product: .unitTests,
      bundleId: "com.ian.\(name)Tests",
      deploymentTarget: deploymentTarget,
      infoPlist: .default,
      sources: ["Targets/\(name)/Tests/**"],
      resources: [],
      dependencies: [
        .target(name: name),
        .external(name: "RxTest"),
        .external(name: "RxNimble")
      ]
    )

    return [sources, tests]
  }

func makeTidifyAppTarget(
  platform: Platform,
  dependencies: [TargetDependency]) -> Target {

    let platform = platform
    let infoPlist: [String: InfoPlist.Value] = [
      "CFBundleShortVersionString": "1.0.3",
      "CFBundleVersion": "1",
      "CFBundleDisplayName": "$(PRODUCT_NAME)",
      "UILaunchStoryboardName": "LaunchScreen",
      "UIUserInterfaceStyle": "Light",
      "CFBundleURLTypes": [
        [
          "CFBundleTypeRole": "Editor",
          "CFBundleURLSchemes": ["kakao${KAKAO_NATIVE_APP_KEY}"]
        ],
        [
          "CFBundleTypeRole": "Editor",
          "CFBundleURLSchemes": ["tidify"]
        ]
      ],
      "KAKAO_NATIVE_APP_KEY": "${KAKAO_NATIVE_APP_KEY}",
      "LSApplicationQueriesSchemes": ["kakaokompassauth", "kakaolink"],
      "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],
      "NSPhotoLibraryAddUsageDescription": "사진첩 접근 권한 요청",
      "UIApplicationSupportsIndirectInputEvents": true,
      "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
      "BASE_URL": "${BASE_URL}",
      "USER_AGENT": "${USER_AGENT}"
    ]

    return .init(
      name: "Tidify",
      platform: platform,
      product: .app,
      bundleId: "com.ian.Tidify",
      deploymentTarget: deploymentTarget,
      infoPlist: .extendingDefault(with: infoPlist),
      sources: ["Targets/Tidify/Sources/**"],
      resources: ["Targets/Tidify/Resources/**"],
      entitlements: "./Tidify.entitlements",
      dependencies: dependencies,
      settings: .settings(base: .init()
        .swiftCompilationMode(.wholemodule)
        .automaticCodeSigning(devTeam: "857J3M5L6B")
      )
    )
  }

func makeShareExtensionTarget(
  platform: Platform,
  dependencies: [TargetDependency]) -> Target {
    let infoPlist: [String: InfoPlist.Value] = [
      "CFBundleDisplayName": "$(PRODUCT_NAME)",
      "NSExtension": [
        "NSExtensionAttributes": [
          "NSExtensionActivationRule": [
            "NSExtensionActivationSupportsImageWithMaxCount": 1,
            "NSExtensionActivationSupportsWebURLWithMaxCount": 1
          ]
        ],
        "NSExtensionMainStoryboard": "MainInterface",
        "NSExtensionPointIdentifier": "com.apple.share-services"
      ]
    ]

    return .init(
      name: "TidifyShareExtension",
      platform: platform,
      product: .appExtension,
      bundleId: "com.ian.Tidify.share",
      deploymentTarget: deploymentTarget,
      infoPlist: .extendingDefault(with: infoPlist),
      sources: ["TidifyShareExtension/Sources/**"],
      resources: ["TidifyShareExtension/Resources/**"],
      entitlements: "TidifyShareExtension/TidifyShareExtension.entitlements",
      settings: .settings(base: .init()
        .automaticCodeSigning(devTeam: "857J3M5L6B")
      )
    )
  }

func makeConfiguration() -> Settings {
  Settings.settings(configurations: [
    .debug(name: "Debug", xcconfig: .relativeToRoot("Targets/Tidify/Config/Debug.xcconfig")),
    .release(name: "Release", xcconfig: .relativeToRoot("Targets/Tidify/Config/Release.xcconfig"))
  ])
}

let project: Project = .init(
  name: "Tidify",
  organizationName: "Tidify",
  settings: makeConfiguration(),
  targets: [
    [makeTidifyAppTarget(
      platform: .iOS,
      dependencies: [
        .target(name: Layer.presentation.layerName),
        .target(name: Layer.data.layerName),
        .target(name: "TidifyShareExtension")
      ]),
     makeShareExtensionTarget(platform: .iOS, dependencies: [])
    ],

    makeTidifyFrameworkTargets(
      name: Layer.presentation.layerName,
      platform: .iOS,
      dependencies: [
        .target(name: Layer.domain.layerName),
        .external(name: "SnapKit"),
        .external(name: "RxCocoa"),
        .external(name: "ReactorKit"),
        .external(name: "Kingfisher"),
        .external(name: "Lottie")
      ]),
    makeTidifyFrameworkTargets(
      name: Layer.data.layerName,
      platform: .iOS,
      dependencies: [
        .target(name: Layer.domain.layerName),
        .external(name: "Moya"),
        .external(name: "RxMoya"),
        .external(name: "RxKakaoSDK")
      ]),
    makeTidifyFrameworkTargets(
      name: Layer.domain.layerName,
      platform: .iOS,
      dependencies: [
        .target(name: Layer.core.layerName)
      ]),
    makeTidifyFrameworkTargets(
      name: Layer.core.layerName,
      platform: .iOS,
      dependencies: [
        .external(name: "RxSwift"),
        .external(name: "RxRelay")
      ])
  ].flatMap { $0 }
)
