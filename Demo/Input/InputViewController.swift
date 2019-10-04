//
//  InputViewController.swift
//  BottomHalfModalDemo
//
//  Created by masamichi on 2019/09/13.
//  Copyright © 2019 merpay, Inc. All rights reserved.
//

import UIKit
import BottomHalfModal

final class InputViewController: UIViewController, SheetContentHeightModifiable {

    let sheetContentHeightToModify: CGFloat = 240

    @IBOutlet private var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNoti(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNoti(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adjustFrameToSheetContentHeightIfNeeded()
        textField.becomeFirstResponder()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        adjustFrameToSheetContentHeightIfNeeded(with: coordinator)
    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func keyboardNoti(noti: Notification) {
        if let rootView = UIApplication.shared.keyWindow {
            // Use rootView's safeAreaInsets becuase view's safeAreaInsets is zero in viewDidAppear although it sometimes needs to animate sheet in viewDidAppear
            animate(with: noti, safeAreaInsets: UIEdgeInsets(top: 0, left: 0, bottom: rootView.safeAreaInsets.bottom, right: 0))
        } else {
            animate(with: noti)
        }
    }
}
