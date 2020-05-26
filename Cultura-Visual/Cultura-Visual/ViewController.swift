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
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           UIGraphicsBeginImageContext(self.view.frame.size)
           UIImage(named: "Unknown")?.draw(in: self.view.bounds)
           let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
           UIGraphicsEndImageContext()
           self.view.backgroundColor = UIColor(patternImage: image)
           
           tfCorreo.text = "a00823402@itesm.mx"
           tfContrasena.text = "123456"
           // Do any additional setup after loading the view.
    }
    
    @IBAction func iniciarSesion(_ sender: Any) {
        
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
                    let navigationMenu = self.storyboard?.instantiateViewController(identifier: "navigationMenu") as? NavController
                    
                    self.view.window?.rootViewController = navigationMenu
                    self.view.window?.makeKeyAndVisible()
                    
                }
            }
        }
        //si no hay texto
        else {
            self.showAlertMessage(title: "Faltan datos", message: "Favor de llenar correo y contraseña")
        }
    }
    
    @IBAction func goToRegister(_ sender: Any) {
        
        let viewRegister = self.storyboard?.instantiateViewController(identifier: "signUp") as? SignUpViewController
        
        self.view.window?.rootViewController = viewRegister
        self.view.window?.makeKeyAndVisible()
    }
    
    func showAlertMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func quitKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

