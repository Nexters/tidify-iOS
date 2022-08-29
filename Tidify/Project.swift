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

private let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "13.0", devices: [.iphone])

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
    dependencies: dependencies
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
    dependencies: [.target(name: name)]
  )

  return [sources, tests]
}

func makeTidifyAppTarget(
  platform: Platform,
  dependencies: [TargetDependency]) -> Target {

  let platform = platform
  let infoPlist: [String: InfoPlist.Value] = [
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "UILaunchStoryboardName": "LaunchScreen",
    "UIUserInterfaceStyle": "Light",
    "CFBundleURLTypes": ["CFBundleTypeRole": "Editor", "CFBundleURLSchemes": ["kakaoc7088851270493d80c903f77ecbad7e5"]],
    "KAKAO_API_KEY": "c7088851270493d80c903f77ecbad7e5",
    "LSApplicationQueriesSchemes": ["kakaokompassauth", "kakaolink"],
    "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],
    "NSPhotoLibraryAddUsageDescription": "사진첩 접근 권한 요청",
    "UIApplicationSupportsIndirectInputEvents": true,
    "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"]
  ]

    return .init(name: "Tidify",
                 platform: platform,
                 product: .app,
                 bundleId: "com.ian.Tidify",
                 deploymentTarget: deploymentTarget,
                 infoPlist: .extendingDefault(with: infoPlist),
                 sources: ["Targets/Tidify/Sources/**"],
                 resources: ["Targets/Tidify/Resources/**"],
                 dependencies: dependencies,
                 settings: .settings(base: .init().automaticCodeSigning(devTeam: "SS72MW26Dn")))
}

let project: Project = .init(
  name: "Tidify",
  organizationName: "Tidify",
  targets: [
    [makeTidifyAppTarget(
      platform: .iOS,
      dependencies: [
        .target(name: Layer.presentation.layerName),
        .target(name: Layer.data.layerName)
    ])],

    makeTidifyFrameworkTargets(
      name: Layer.presentation.layerName,
      platform: .iOS,
      dependencies: [
        .target(name: Layer.domain.layerName),
        .external(name: "SnapKit"),
        .external(name: "Then"),
        .external(name: "RxCocoa"),
        .external(name: "ReactorKit"),
        .external(name: "Kingfisher")
      ]),
     makeTidifyFrameworkTargets(
      name: Layer.data.layerName,
      platform: .iOS,
      dependencies: [
        .target(name: Layer.domain.layerName),
        .external(name: "Moya"),
        .external(name: "RxMoya")
      ]),
     makeTidifyFrameworkTargets(
      name: Layer.domain.layerName,
      platform: .iOS,
      dependencies: [
        .target(name: Layer.core.layerName),
        .external(name: "RxKakaoSDK")
      ]),
    makeTidifyFrameworkTargets(
      name: Layer.core.layerName,
      platform: .iOS,
      dependencies: [
        .external(name: "RxSwift"),
        .external(name: "RxRelay"),
        .external(name: "SwiftyBeaver"),
      ])
  ].flatMap { $0 }
)
