//
//  Notifier.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/13.
//

import Foundation
import UIKit

enum Notifier {
    typealias Action = () -> Void
    typealias AlertButtonAction = (title: String, Action: Action?)

    static func alert(on viewController: UIViewController?, title: String, message: String, buttons: [AlertButtonAction]) {
        guard let viewController = viewController else {
            return
        }

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.t_addTap().rx.event.asDriver()
            .drive(onNext: { _ in
                alertController.dismiss(animated: true, completion: nil)
            })
            .dispose()

        alertController.addAction(UIAlertAction(title: buttons.first?.title ?? "OK", style: .default, handler: { _ in
            buttons.first?.Action?()
        }))

        if buttons.count > 1 {
            for button in buttons[1...] {
                alertController.addAction(UIAlertAction(title: button.title, style: .default, handler: { _ in
                    button.Action?()
                }))
            }
        }

        viewController.present(alertController, animated: true, completion: nil)
    }
}
