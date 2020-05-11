//
//  editaPerfilViewController.swift
//  Cultura-Visual
//
//  Created by user168641 on 5/9/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit
import Firebase

class editaPerfilViewController: UIViewController {

    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfApellido: UITextField!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        
        let user = Auth.auth().currentUser
        var ref: DatabaseReference!

        ref = Database.database().reference()
        if let user = user {
          // The user's ID, unique to the Firebase project.
          // Do NOT use this value to authenticate with your backend server,
          // if you have one. Use getTokenWithCompletion:completion: instead.
          let uid = user.uid
          let email = user.email
          let photoURL = user.photoURL
          var multiFactorString = "MultiFactor: "
          for info in user.multiFactor.enrolledFactors {
            multiFactorString += info.displayName ?? "[DispayName]"
            multiFactorString += " "
          }
            tfNombre.text = multiFactorString
        }
         */
        


        // Do any additional setup after loading the view.
    }
    
    @IBAction func btEditar(_ sender: UIButton) {
    }
    @IBAction func btContra(_ sender: UIButton) {
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
