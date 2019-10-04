//
//  SheetPresentationController.swift
//  BottomHalfModal
//
//  Created by jarinosuke on 2018/02/09.
//  Copyright © 2018 merpay, Inc. All rights reserved.
//

import Foundation
import UIKit

// MARK: - SheetContentHeightModifiable

public protocol SheetContentHeightModifiable {
    var sheetContentHeightToModify: CGFloat { get }
    func adjustFrameToSheetContentHeightIfNeeded(with coordinator: UIViewControllerTransitionCoordinator)
}

public enum SheetContentHeight {
    public static let `default`: CGFloat = 320
}

// MARK: - SheetControllerContentSizing

protocol SheetControllerContentSizing {
    var sheetContentHeight: CGFloat { get set }
}

extension SheetContentHeightModifiable where Self: UIViewController {
    public func adjustFrameToSheetContentHeightIfNeeded() {
        self.sheetContentHeight = self.sheetContentHeightToModify
    }

    public func adjustFrameToSheetContentHeightIfNeeded(with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil) { [weak self] _ in
            guard let strongSelf = self else { return }
            if strongSelf.navigationController?.topViewController == strongSelf {
                strongSelf.adjustFrameToSheetContentHeightIfNeeded()
            }
        }
    }
}

extension UIViewController: SheetControllerContentSizing {

    /**
     to invoke SheetPresentationController - preferredContentSizeDidChange,
     if self.navigationController exists, change its preferredContentSize instead of this to invoke correctly.
     */
    var sheetContentHeight: CGFloat {
        get {
            guard let nav = navigationController else { return preferredContentSize.height }
            return nav.preferredContentSize.height
        }
        set {
            let width = view.bounds.width
            let additionalBottomHeight: CGFloat
            if let windowWithSafeArea = UIApplication.shared.windows.first(where: { $0.safeAreaInsets.bottom > 0 }) {
                // If there is a window with safeArea, we use SafeAreaInsets of it because SafeAreaInsets of self.view is not updated in viewDidAppear in the first view controller.
                // Keywindow is sometimes different from application main window(ex. Banner), we don't use UIApplication.shared.keyWindow.
                additionalBottomHeight = windowWithSafeArea.safeAreaInsets.bottom
            } else {
                additionalBottomHeight = 0
            }
            if let nav = navigationController {
                nav.preferredContentSize = CGSize(width: width, height: newValue + additionalBottomHeight)
            } else {
                preferredContentSize = CGSize(width: view.bounds.width, height: newValue + additionalBottomHeight)
            }
        }
    }

    // MARK: Convenience methods

    public func animate(with keyboardNotification: Notification, safeAreaInsets: UIEdgeInsets = UIEdgeInsets.zero) {
        guard let sheetPresentationController = navigationController?.presentationController as? SheetPresentationController else { return }
        sheetPresentationController.animateContainerView(with: keyboardNotification, safeAreaInsets: safeAreaInsets)
    }
}

final class SheetPresentationController: UIPresentationController {

    // MARK: - Internal

    func animateContainerView(with notification: Notification, safeAreaInsets: UIEdgeInsets) {
        guard let keyboardBeginFrame = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
            let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            keyboardBeginFrame != keyboardEndFrame else {
                return
        }

        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
        let option = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? 0
        let options = UIView.AnimationOptions(rawValue: option)

        let vc = presentedViewController
        let isMovingIn = keyboardBeginFrame.origin.y > keyboardEndFrame.origin.y
        let y: CGFloat

        let containerHeight = containerView!.frame.height
        let vcBeginY = containerHeight - vc.view.frame.height
        if isMovingIn {
            let minThresholdY: CGFloat = 40
            let toY = vcBeginY - keyboardEndFrame.height
            y = toY < minThresholdY ? minThresholdY : toY
        } else {
            y = vcBeginY
        }

        let frame = CGRect(
            x: vc.view.frame.origin.x,
            y: y,
            width: vc.view.frame.width,
            height: vc.view.frame.height
        )
        animateContainerView(
            with: vc,
            frame: frame,
            duration: duration,
            options: options,
            useSpringDamping: false,
            safeAreaInsets: safeAreaInsets
        )
    }

    // MARK: - Private

    private func setupContainerView() {
        containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        containerView?.alpha = 0
    }

    /**
     default value of duration and options are same as UIViewController's transition
     */

    private func animateContainerView(
        with viewController: UIViewController,
        frame: CGRect,
        duration: TimeInterval = 0.35,
        options: UIView.AnimationOptions = [.allowUserInteraction, .beginFromCurrentState],
        useSpringDamping: Bool = true,
        safeAreaInsets: UIEdgeInsets = UIEdgeInsets.zero
        ) {

        if useSpringDamping {
            UIView.animate(
                withDuration: duration,
                delay: 0,
                usingSpringWithDamping: 100.0,
                initialSpringVelocity: 2.0,
                options: options,
                animations: { [safeAreaInsets] in
                    viewController.view.frame = frame
                    if viewController.view.safeAreaInsets == UIEdgeInsets.zero {
                        viewController.additionalSafeAreaInsets = safeAreaInsets
                    } else {
                        viewController.additionalSafeAreaInsets = UIEdgeInsets.zero
                    }
                }, completion: nil
            )
        } else {
            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: options,
                animations: { [safeAreaInsets] in
                    viewController.view.frame = frame
                    if viewController.view.safeAreaInsets == UIEdgeInsets.zero {
                        // Keyboard sometimes erases the view's safeAreaInsets and sheet content height becomes wrong value. Setting the additionalSafeAreaInsets when safeAreaInsets is zero fixes the bug.
                        viewController.additionalSafeAreaInsets = safeAreaInsets

                    } else {
                        viewController.additionalSafeAreaInsets = UIEdgeInsets.zero
                    }
                }, completion: nil
            )
        }

    }

    // MARK: - Override

    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        guard let vc = container as? UIViewController,
            let containerView = containerView else {
                return
        }
        let viewSize = vc.preferredContentSize
        let containerViewFrame = containerView.bounds
        let frame = CGRect(
            x: containerViewFrame.origin.x,
            y: containerViewFrame.size.height - viewSize.height,
            width: viewSize.width,
            height: viewSize.height
        )
        animateContainerView(with: vc, frame: frame)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }

        setupContainerView()
        // Fade-in bg container view
        containerView.alpha = 0.0
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(
                alongsideTransition: { _ in
                    self.containerView?.alpha = 1.0
            },
                completion: nil
            )
        }
    }

    override func dismissalTransitionWillBegin() {
        // Fade-out bg container view
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(
                alongsideTransition: { _ in
                    self.containerView?.alpha  = 0.0
            },
                completion: nil
            )
        }
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        let frame = containerView.bounds
        let sheetHeight = presentedViewController.preferredContentSize.height
        return CGRect(
            x: 0,
            y: frame.height - sheetHeight,
            width: frame.width,
            height: sheetHeight
        )
    }
}
