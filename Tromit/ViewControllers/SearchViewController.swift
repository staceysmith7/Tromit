//
//  FindViewController.swift
//  Tromit
//
//
//  Copyright © 2018 Devstek. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var searchBar = UISearchBar()
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        searchBar.delegate = self
        searchBar.frame.size.width = view.frame.size.width - 60
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
        
        doSearch()
    }
    
    func doSearch() {
        if let searchText = searchBar.text?.lowercased() {self.users.removeAll()
            self.tableView.reloadData()
            Api.User.queryUsers(withText: searchText) { (user) in
                self.isFollowing(userId: user.id!, completed: {
                    (value) in
                    user.isFollowing = value
                    self.users.append(user)
                    self.tableView.reloadData()
                    
                })
            }
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        doSearch()
//    }
    
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        Api.Follow.isFollowing(userId: userId, completed: completed)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToProfileSegue" {
            let profileVC = segue.destination as! ProfileUserViewController
            let userId = sender as! String
            profileVC.userId = userId
            profileVC.delegate = self
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        doSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch()
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        let user = users[indexPath.row]
        cell.user = user
        cell.delegate = self
        return cell
    }
}

extension SearchViewController: PeopleTableViewCellDelegate {
    func goToProfileUserVC (userId: String) {
        performSegue(withIdentifier: "SearchToProfileSegue", sender: userId)
    }
}

extension SearchViewController: HeaderProfileCollectionReusableViewDelegate {
    func updateFollowButton(forUser user: User) {
        for u in self.users {
            if u.id == user.id{
                u.isFollowing = user.isFollowing
                self.tableView.reloadData()
            }
        }
    }
}

