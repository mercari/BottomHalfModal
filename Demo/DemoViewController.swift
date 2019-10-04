//
//  DemoViewController.swift
//  BottomHalfModalDemo
//
//  Created by masamichi on 2019/09/12.
//  Copyright © 2019 merpay, Inc. All rights reserved.
//

import UIKit
import BottomHalfModal

final class DemoViewController: UITableViewController {

    typealias Cell = (text: String, action: () -> Void)

    var cells: [Cell] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        cells = [
            (
                text: "Basic",
                action: { [weak self] in
                    let nav = BottomHalfModalNavigationController(rootViewController: BasicViewController())
                    self?.navigationController?.present(nav, animated: true, completion: nil)
                }
            ),
            (
                text: "TableView",
                action: { [weak self] in
                    let nav = BottomHalfModalNavigationController(rootViewController: TableViewController(style: .plain))
                    self?.present(nav, animated: true, completion: nil)
                }
            ),
            (
                text: "Navigation",
                action: { [weak self] in
                    let nav = BottomHalfModalNavigationController(rootViewController: NavigationViewController())
                    self?.present(nav, animated: true, completion: nil)
                }
            ),
            (
                text: "Sticky Button",
                action: { [weak self] in
                    let nav = BottomHalfModalNavigationController(rootViewController: StickyButtonViewController())
                    self?.present(nav, animated: true, completion: nil)
                }
            ),
            (
                text: "Input",
                action: { [weak self] in
                    let nav = BottomHalfModalNavigationController(rootViewController: InputViewController())
                    self?.present(nav, animated: true, completion: nil)
                }
            )
        ]
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let (text, _) = cells[indexPath.row]
        cell.textLabel?.text = text
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (_, action) = cells[indexPath.row]
        action()
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
