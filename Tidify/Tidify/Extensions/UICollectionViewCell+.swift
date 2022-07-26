//
//  UICollectionViewCell+.swift
//  Tidify
//
//  Created by 한상진 on 2022/03/15.
//

import UIKit

import RxSwift
import RxRelay

public extension UICollectionViewCell {
    func t_initSwipeView(swipeView: UIStackView, width: CGFloat, isSwiped: BehaviorRelay<Bool>) {
        swipeView.frame.origin.x = width
        isSwiped.accept(false)
    }
    
    func t_panSwipeAction(
        _ panGestureRecognizer: UIPanGestureRecognizer,
        swipeView: UIStackView,
        isSwiped: BehaviorRelay<Bool>,
        width: CGFloat,
        disposeBag: DisposeBag) {
            panGestureRecognizer.rx.event
                .map { $0 .state }
                .bind { [weak self] in
                    guard let self = self else { return }
                    switch $0 {
                    case .changed:
                        self.setNeedsLayout()
                    case .ended:
                        if swipeView.center.x < 331 {
                            UIView.animate(withDuration: 0.3, animations: {
                                swipeView.frame.origin.x = width - swipeView.frame.width
                                self.layoutIfNeeded()
                            })
                            isSwiped.accept(true)
                        } else {
                            UIView.animate(withDuration: 0.3, animations: {
                                self.t_initSwipeView(swipeView: swipeView, width: width, isSwiped: isSwiped)
                            })
                        }
                    default: return
                    }
                }
                .disposed(by: disposeBag)
        }
}
