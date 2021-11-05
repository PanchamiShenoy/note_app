//
//  MenuViewController.swift
//  SignUpLoginDemo
//
//  Created by Panchami Shenoy on 25/10/21.
//

import UIKit
import FBSDKLoginKit

class MenuViewController: UITableViewController {

    var menuItems = ["Home","Profile","Logout"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 50
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuCell
        cell.textLabel?.text = menuItems[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if menuItems[indexPath.row] == "Logout" {
            do {
               NetworkManager.shared.signout()
                NetworkManager.shared.googleSignOut()
                LoginManager.init().logOut()
                transitionToLogin()
                } catch {
                      showAlert(title: "Error", message: "error in signing out")
                    return
                }
        }
        if menuItems[indexPath.row] == "Profile" {
            let profileController = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            profileController.modalPresentationStyle = .fullScreen
            present(profileController,animated: true,completion: nil)
        }
    }
    func transitionToLogin() {
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: "SigninVC")
        
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
}
