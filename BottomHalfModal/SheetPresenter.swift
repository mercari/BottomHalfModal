//
//  SheetPresenter.swift
//  BottomHalfModal
//
//  Created by masamichi on 2019/10/09.
//  Copyright © 2019 merpay, Inc. All rights reserved.
//

import UIKit

public protocol SheetPresenter {
    func presentBottomHalfModal(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?)
}

extension UIViewController: SheetPresenter {
    public func presentBottomHalfModal(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) {
        viewControllerToPresent.modalPresentationStyle = .custom
        viewControllerToPresent.transitioningDelegate = SheetPresentationDelegate.default
        present(viewControllerToPresent, animated: animated, completion: completion)
    }
}
