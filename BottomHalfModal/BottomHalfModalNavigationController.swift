//
//  BottomHalfNavigationController.swift
//  BottomHalfModal
//
//  Created by ku on 2018/04/26.
//  Copyright © 2018 merpay, Inc. All rights reserved.
//

import UIKit

open class BottomHalfModalNavigationController: UINavigationController {
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0, let vc = viewController as? SheetContentHeightModifiable {
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
