import ProjectDescription

let dependencies = Dependencies(
  swiftPackageManager: .init(
    [
      .remote(url: "https://github.com/kakao/kakao-ios-sdk-rx.git", requirement: .upToNextMajor(from: "2.0.0")),
      .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMinor(from: "5.0.0")),
      .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .upToNextMinor(from: "6.5.0")),
      .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMinor(from: "6.3.0")),
      .remote(url: "https://github.com/Moya/Moya.git", requirement: .upToNextMinor(from: "15.0.0")),
      .remote(url: "https://github.com/mac-cain13/R.swift.Library.git", requirement: .branch("master")),
      .remote(url: "https://github.com/ReactorKit/ReactorKit.git", requirement: .upToNextMinor(from: "3.2.0")),
      .remote(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", requirement: .upToNextMinor(from: "1.9.0")),
      .remote(url: "https://github.com/devxoul/Then", requirement: .upToNextMinor(from: "2.7.0")),
      .remote(url: "https://github.com/RxSwiftCommunity/RxNimble.git", requirement: .upToNextMajor(from: "5.0.0"))
    ]
  ),
  platforms: [.iOS]
)
