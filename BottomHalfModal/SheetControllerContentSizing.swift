//
//  SheetControllerContentSizing.swift
//  BottomHalfModal
//
//  Created by masamichi on 2019/10/09.
//  Copyright © 2019 merpay, Inc. All rights reserved.
//

import UIKit

protocol SheetControllerContentSizing {
    var sheetContentHeight: CGFloat { get set }
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
                preferredContentSize = CGSize(width: width, height: newValue + additionalBottomHeight)
            }
        }
    }

    // MARK: Convenience methods

    public func animate(with keyboardNotification: Notification, safeAreaInsets: UIEdgeInsets = UIEdgeInsets.zero) {
        guard let sheetPresentationController = navigationController?.presentationController as? SheetPresentationController else { return }
        sheetPresentationController.animateContainerView(with: keyboardNotification, safeAreaInsets: safeAreaInsets)
    }
}
