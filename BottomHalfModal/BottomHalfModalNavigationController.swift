//
//  BottomHalfNavigationController.swift
//  BottomHalfModal
//
//  Created by ku on 2018/04/26.
//  Copyright © 2018 merpay, Inc. All rights reserved.
//

import UIKit

open class BottomHalfModalNavigationController: UINavigationController {
    public init() {
        super.init(navigationBarClass: UINavigationBar.self, toolbarClass: nil)
        commonInit()
    }

    public override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: UINavigationBar.self, toolbarClass: nil)
        viewControllers = [rootViewController]
        commonInit()
    }

    @available(*, unavailable)
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? SheetContentHeightModifiable {
            sheetContentHeight = vc.sheetContentHeightToModify
        }
        super.pushViewController(viewController, animated: animated)
    }

    override open func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)
        if let vc = visibleViewController as? SheetContentHeightModifiable {
            sheetContentHeight = vc.sheetContentHeightToModify
        }
        return vc
    }

    override open func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let vcs = super.popToRootViewController(animated: animated)
        if let vc = visibleViewController as? SheetContentHeightModifiable {
            sheetContentHeight = vc.sheetContentHeightToModify
        }
        return vcs
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension BottomHalfModalNavigationController: UIViewControllerTransitioningDelegate {
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
        ) -> UIPresentationController? {
        guard presented == self else { return nil }
        return SheetPresentationController(presentedViewController: presented, presenting: presenting)
    }

    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        guard presented == self else { return nil }
        return SheetAnimationController(forPresenting: true)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard dismissed == self else { return nil }
        return SheetAnimationController(forPresenting: false)
    }

}

