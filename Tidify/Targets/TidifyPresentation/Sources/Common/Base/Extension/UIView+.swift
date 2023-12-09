//
//  UIView+.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Combine
import UIKit

public extension UIView {
  var tapPublisher: AnyPublisher<Void, Never> {
    TapPublisher(view: self)
      .subscribe(on: DispatchQueue.main)
      .map { _ in }
      .eraseToAnyPublisher()
  }

  func addTap() -> UITapGestureRecognizer {
    let tapGestureRecognizer: UITapGestureRecognizer = .init()
    addGestureRecognizer(tapGestureRecognizer)

    return tapGestureRecognizer
  }

  func cornerRadius(_ corners: [UIRectCorner] = [.allCorners], radius: CGFloat) {
    layer.masksToBounds = true
    layer.cornerCurve = .continuous
    layer.cornerRadius = radius

    if corners != [.allCorners] {
      var cornerMask: CACornerMask = .init()

      corners.forEach {
        if $0 == .topLeft {
          cornerMask.insert(.layerMinXMinYCorner)
        }
        if $0 == .topRight {
          cornerMask.insert(.layerMaxXMinYCorner)
        }
        if $0 == .bottomLeft {
          cornerMask.insert(.layerMinXMaxYCorner)
        }
        if $0 == .bottomRight {
          cornerMask.insert(.layerMaxXMaxYCorner)
        }
      }

      layer.maskedCorners = cornerMask
    }
  }
}

fileprivate extension UIView {
  struct TapPublisher: Publisher {
    typealias Output = UITapGestureRecognizer
    typealias Failure = Never

    let view: UIView

    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
      let tapGesture = TapGestureRecognizer()
      view.addGestureRecognizer(tapGesture)
      let subscription = TapGestureSubscription(subscriber: subscriber, gesture: tapGesture)
      subscriber.receive(subscription: subscription)
    }
  }

  final class TapGestureSubscription<S: Subscriber>: Subscription where S.Input == UITapGestureRecognizer, S.Failure == Never {

    // MARK: Properties
    private var subscriber: S?
    private var gesture: TapGestureRecognizer?
    private var cancellables: Set<AnyCancellable> = .init()

    // MARK: Initializer
    init(subscriber: S, gesture: TapGestureRecognizer) {
      self.subscriber = subscriber
      self.gesture = gesture

      gesture.tappedSubject.sink { [weak self] tap in
        _ = self?.subscriber?.receive(tap)
      }
      .store(in: &cancellables)
    }

    // MARK: Methods
    func request(_ demand: Subscribers.Demand) {}

    func cancel() {
      subscriber = nil
      gesture = nil
    }
  }

  final class TapGestureRecognizer: UITapGestureRecognizer {
    let tappedSubject = PassthroughSubject<UITapGestureRecognizer, Never>()

    override init(target: Any?, action: Selector?) {
      super.init(target: target, action: action)
      addTarget(self, action: #selector(tap))
    }

    @objc private func tap(sender: UITapGestureRecognizer) {
      tappedSubject.send(sender)
    }
  }
}
