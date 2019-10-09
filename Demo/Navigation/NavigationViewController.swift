//
//  NavigationViewController.swift
//  BottomHalfModalDemo
//
//  Created by masamichi on 2019/09/13.
//  Copyright © 2019 merpay, Inc. All rights reserved.
//

import UIKit
import BottomHalfModal

final class NavigationViewController: UIViewController, SheetContentHeightModifiable {

    let sheetContentHeightToModify: CGFloat = 280

    init() {
        super.init(nibName: nil, bundle: Bundle(for: NavigationViewController.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adjustFrameToSheetContentHeightIfNeeded()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        adjustFrameToSheetContentHeightIfNeeded(with: coordinator)
    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func push(_ sender: Any) {
        navigationController?.pushViewController(PushViewController(), animated: true)
    }

    @IBAction private func presentAnotherHalfModal(_ sender: Any) {
        let vc = PresentViewController()
        let nav = BottomHalfModalNavigationController(rootViewController: vc)
        presentBottomHalfModal(nav, animated: true, completion: nil)
    }

    @IBAction private func presentOverCurrentContext(_ sender: Any) {
        let vc = PresentOverCurrentContextViewController()
        let nav = BottomHalfModalNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overCurrentContext
        presentBottomHalfModal(nav, animated: true, completion: nil)
    }

    @IBAction private func presentOverFullScreen(_ sender: Any) {
        let vc = PresentOverFullScreenViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil)
    }
}
