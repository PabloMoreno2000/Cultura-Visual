//
//  ViewController.swift
//  Cultura-Visual
//
//  Created by user168627 on 4/8/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var tfCorreo: UITextField!
    @IBOutlet weak var tfContrasena: UITextField!
    @IBOutlet weak var bEntrar: UIButton!
    
    @IBAction func iniciarSesion(_ sender: UIButton) {
        
        //If there is text
        if let correo = tfCorreo.text, let contrasena = tfContrasena.text {
            //Try to log with the clean text
            Auth.auth().signIn(withEmail: Utilities.cleanString(s: correo), password: Utilities.cleanString(s: contrasena)){
                (result, error) in
                
                if error != nil {
                    if(Utilities.cleanString(s: correo) == "" || Utilities.cleanString(s: contrasena) == ""){
                        self.showAlertMessage(title: "Faltan datos", message: "Favor de llenar correo y contraseña")
                        
                    }
                    else {
                        //print error
                        self.showAlertMessage(title: "Cuenta no encontrada", message: "Intente de nuevo")
                    }

                }
                else {

                    //go to main menu
                    let mainMenu = self.storyboard?.instantiateViewController(identifier: "mainMenu") as? MainMenu
                    
                    self.view.window?.rootViewController = mainMenu
                    self.view.window?.makeKeyAndVisible()
                    
                }
            }
        }
        //si no hay texto
        else {
            self.showAlertMessage(title: "Faltan datos", message: "Favor de llenar correo y contraseña")
        }
    }
    
    func showAlertMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

