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

    static func alert(on viewController: UIViewController?, title: String, message: String, buttons: [AlertButtonAction]? = nil) {
        guard let viewController = viewController else {
            return
        }

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: buttons?.first?.title ?? "OK", style: .default, handler: { _ in
            buttons?.first?.Action?()
        }))

        if let buttons = buttons, buttons.count > 1 {
            for button in buttons[1...] {
                alertController.addAction(UIAlertAction(title: button.title, style: .default, handler: { _ in
                    button.Action?()
                }))
            }
        }

        // 버튼 색상 좀 더 깔쌈하게 배경색상 바꿀수 있는 방법 추후 리팩토링
        alertController.view.subviews.first?.subviews.first?.backgroundColor = .t_indigoBlue()
        alertController.view.subviews.first?.subviews[1].backgroundColor = .t_tidiBlue()

        viewController.present(alertController, animated: true, completion: nil)
    }
}
