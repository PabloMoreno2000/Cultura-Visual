//
//  SignUpViewController.swift
//  Cultura-Visual
//
//  Created by user168625 on 4/18/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func isPasswordValide(password : String) -> Bool {
    
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    //check the fields and validate that the data is correct.
    func validateFields() -> String? {
        
        //check the fields are not empty
        if tfName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || tfLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || tfConfirmPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Llena todos los campos."
        }
        
        let cleanedPassword = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValide(password: cleanedPassword) == false {
            
            return "Tu contraseña debe tener 8 caracteres, un caracter especial y un número"
        }
        
        return nil
    }
    
    func transitionToMenu() {
        
        let mainMenu = self.storyboard?.instantiateViewController(identifier: "mainMenu") as? MainMenu
        
        self.view.window?.rootViewController = mainMenu
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        
        //validate the fields
        let error = validateFields()
        
        if error != nil {
            
            self.showError(title: "Campos Incorrectos", message: error!)
        }
        else {
            
            let firstName = tfName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = tfLastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    self.showError(title: "Error", message: err!.localizedDescription)
                }
                else {
                    //user created, now store the name and last name
                    let db = Firestore.firestore()
                    
                    db.collection("usuarios").addDocument(data: ["nombre":firstName, "apellido":lastName, "esAdmin": false, "correo": email, "contrasena":password, "uid": result!.user.uid]) { (error) in
                        
                        if error != nil {
                            
                            self.showError(title: "Error al guardar los datos", message: error!.localizedDescription)
                        }
                        
                    }
                    
                    //transition to home screen
                    self.transitionToMenu()
                }
            }
        }
    }
    
    func showError(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        
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
