//
//  BaseTableViewController.swift
//  MessageChat
//
//  Created by Luciano Pezzin on 10/12/2018.
//  Copyright © 2018 Bruno iOS Dev. All rights reserved.
//

import UIKit

class BaseTableViewController<I: BaseCell<B>, B>: UITableViewController {

    let cellid = "cellid"
    
    var items = [B]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(I.self, forCellReuseIdentifier: cellid)
        tableView.tableFooterView = UIView()
        
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = rc
    }

    @objc func handleRefresh() {
        tableView.refreshControl?.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! BaseCell<B>
        cell.item = self.items[indexPath.row]
        return cell
    }
}
