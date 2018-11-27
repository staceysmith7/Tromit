//
//  PeopleViewController.swift
//  Tromit
//
//  Created by Stacey Smith on 11/27/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {

    var users: [User] = [ ]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         loadUsers()
    }
    
        func loadUsers () {
            Api.User.observeUsers() { (user) in
                self.users.append(user)
                self.tableView.reloadData()
            }
        }
}

extension PeopleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
}

