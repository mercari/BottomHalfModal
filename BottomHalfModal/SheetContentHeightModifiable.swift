//
//  SheetContentHeightModifiable.swift
//  BottomHalfModal
//
//  Created by masamichi on 2019/10/09.
//  Copyright © 2019 merpay, Inc. All rights reserved.
//

import UIKit

public protocol SheetContentHeightModifiable {
    var sheetContentHeightToModify: CGFloat { get }
    func adjustFrameToSheetContentHeightIfNeeded(with coordinator: UIViewControllerTransitionCoordinator)
}

extension SheetContentHeightModifiable where Self: UIViewController {
    public func adjustFrameToSheetContentHeightIfNeeded() {
        self.sheetContentHeight = self.sheetContentHeightToModify
    }

    public func adjustFrameToSheetContentHeightIfNeeded(with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil) { [weak self] _ in
            guard let strongSelf = self else { return }
            if let nav = strongSelf.navigationController {
                if nav.topViewController == strongSelf {
                    strongSelf.adjustFrameToSheetContentHeightIfNeeded()
                }
            } else {
                strongSelf.adjustFrameToSheetContentHeightIfNeeded()
            }
        }
    }
}
