//
// ActivityViewController.swift
//  Tromit
//
//  Created by Stacey Smith on 11/19/18.
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit
import FirebaseAuth

class ActivityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var notifications = [Notification]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotifications()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    func loadNotifications() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        Api.Notification.observeNotification(withId: currentUser.uid, completion: {
            notification in
            guard let uid = notification.from else {
                return
            }
            self.fetchUser(uid: uid, completed: {
                self.notifications.insert(notification, at: 0)
                //self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            })
        })
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void ) {
        
        Api.User.observeUser(withId: uid, completion: {
            user in
            self.users.insert(user, at: 0)
            completed()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ActivityDetailSegue" {
            let detailVC = segue.destination as! DetailViewController
            let postId = sender as! String
            detailVC.postId = postId
        }
    }

}

extension ActivityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
        let notification = notifications[indexPath.row]
        let user = users[indexPath.row]
        cell.notification = notification
        cell.user = user
        cell.delegate = self
        return cell
    }
}

extension ActivityViewController: ActivityTableViewCellDelegate {
    
    func goToDetailVC(postId: String) {
        performSegue(withIdentifier: "ActivityDetailSegue", sender: postId)
    }
}
