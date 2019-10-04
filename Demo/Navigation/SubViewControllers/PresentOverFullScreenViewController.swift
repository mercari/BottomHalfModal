//
//  PresentOverFullScreenViewController.swift
//  BottomHalfModalDemo
//
//  Created by masamichi on 2019/09/13.
//  Copyright © 2019 merpay, Inc. All rights reserved.
//

import UIKit

final class PresentOverFullScreenViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: Bundle(for: PresentOverFullScreenViewController.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
    }

    @objc func close() {
        dismiss(animated: true, completion: nil)
    }

}
