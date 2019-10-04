//
//  SheetAnimationController.swift
//  BottomHalfModal
//
//  Created by jarinosuke on 2018/02/09.
//  Copyright © 2018 merpay, Inc. All rights reserved.
//

import Foundation
import UIKit

final class SheetAnimationController: NSObject {
    let forPresenting: Bool
    let duration: TimeInterval = 0.25

    init(forPresenting: Bool) {
        self.forPresenting = forPresenting

        super.init()
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension SheetAnimationController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if forPresenting {
            animatePresentationWithTransitionContext(transitionContext)
        } else {
            animateDismissalWithTransitionContext(transitionContext)
        }
    }

    func animatePresentationWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedController = transitionContext.viewController(forKey: .to),
            let presentedControllerView = transitionContext.view(forKey: .to) else {
                return
        }

        let containerView = transitionContext.containerView

        // Position the presented view off the top of the container view
        presentedControllerView.frame = transitionContext.finalFrame(for: presentedController)
        presentedControllerView.frame.size.height = containerView.bounds.size.height
        presentedControllerView.center.y += containerView.bounds.size.height

        containerView.addSubview(presentedControllerView)

        // Animate the presented view to it's final position
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.5,
            options: .allowUserInteraction,
            animations: {
                presentedControllerView.center.y -= containerView.bounds.size.height
        },
            completion: { (completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
        })
    }

    func animateDismissalWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedControllerView = transitionContext.view(forKey: .from) else {
            return
        }

        let containerView = transitionContext.containerView

        // Animate the presented view off the bottom of the view
        UIView.animate(
            withDuration: duration + 0.5, // make slow down
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.5,
            options: .allowUserInteraction,
            animations: {
                presentedControllerView.center.y += containerView.bounds.size.height
        }, completion: {(completed: Bool) -> Void in
            transitionContext.completeTransition(completed)
            if !self.forPresenting {
                let fromVC = transitionContext.viewController(forKey: .from)
                fromVC?.view?.removeFromSuperview()
            }
        })
    }
}
