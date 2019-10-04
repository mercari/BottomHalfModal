//
//  TableViewController.swift
//  BottomHalfModal
//
//  Created by masamichi on 2019/09/12.
//  Copyright © 2019 merpay, Inc. All rights reserved.
//

import UIKit
import BottomHalfModal

final class TableViewController: UITableViewController, SheetContentHeightModifiable {

    var sheetContentHeightToModify: CGFloat = SheetContentHeight.default

    let cells: [String] = [
        "Building",
        "Trust",
        "For",
        "A",
        "Seamless",
        "Society",
        "Go Bold",
        "All for One",
        "Be a Pro"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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

    @objc func close() {
        dismiss(animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = cells[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        return cell
    }
}
