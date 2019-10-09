//
//  SheetPresentationDelegate.swift
//  BottomHalfModal
//
//  Created by masamichi on 2019/10/09.
//  Copyright © 2019 merpay, Inc. All rights reserved.
//

import UIKit

public class SheetPresentationDelegate: NSObject {

    public static var `default`: SheetPresentationDelegate = {
        return SheetPresentationDelegate()
    }()

}

extension SheetPresentationDelegate: UIViewControllerTransitioningDelegate {
    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
        ) -> UIPresentationController? {
        return SheetPresentationController(presentedViewController: presented, presenting: presenting)
    }

    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        return SheetAnimationController(forPresenting: true)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SheetAnimationController(forPresenting: false)
    }
}
