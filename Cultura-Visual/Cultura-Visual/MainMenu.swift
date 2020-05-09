//
//  MainMenu.swift
//  Cultura-Visual
//
//  Created by user168627 on 4/8/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit

import Firebase

class MainMenu: UIViewController {

    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var leading: NSLayoutConstraint!
    
    var menuOut = false
    
    @IBAction func hambutton(_ sender: UIBarButtonItem) {
        if menuOut == false{
            leading.constant = 150
            trailing.constant = -150
            menuOut = true
        }
        else {
            leading.constant = 0
            trailing.constant = 0
            menuOut = false
        }
        UIView.animate(withDuration: 0.2, delay : 0.0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()})
    }
    
    @IBAction func logoutbutton(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
  
            try firebaseAuth.signOut()
            let signInScreen = self.storyboard?.instantiateViewController(identifier: "signIn") as? ViewController
            
            self.view.window?.rootViewController = signInScreen
            self.view.window?.makeKeyAndVisible()

        } catch let signOutError as NSError {
  
            print ("Error signing out: %@", signOutError)

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
