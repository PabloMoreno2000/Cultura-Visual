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

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vistaRegistro: UIView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    
    var activeField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = vistaRegistro.frame.size
        registrarseParaNotificacionesDeTeclado()
        
        UIGraphicsBeginImageContext(self.vistaRegistro.frame.size)
        UIImage(named: "Unknown")?.draw(in: self.vistaRegistro.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.vistaRegistro.backgroundColor = UIColor(patternImage: image)
        
        /*let tap = UITapGestureRecognizer(target: self, action: #selector(quitKeyboard))
        self.view.addGestureRecognizer(tap)
        self.registrarseParaNotificacionesDeTeclado()*/
    }
    
    @IBAction func regresarInicio(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - REGISTRO
    
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
            
            return "Tu contraseña debe tener 8 caracteres incluyendo un caracter especial y un número"
        }
        
        let cleanedConfirmation = tfConfirmPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedPassword != cleanedConfirmation {
            
            return "Contraseñas no coinciden"
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
            
            self.showError(title: "Error", message: error!)
        }
        else {
            
            let firstName = tfName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = tfLastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    
                    if let errorDescription = err as NSError? {
                        switch AuthErrorCode(rawValue: errorDescription.code) {
                        case .emailAlreadyInUse:
                            self.showError(title: "Error", message: "El correo ya está registrado")
                        case .invalidEmail:
                            self.showError(title: "Error", message: "El correo esta mal formateado")
                        default:
                            self.showError(title: "Error", message: "La cuenta no se ha podido registrarse")
                        }
                    }
                }
                else {
                    //user created, now store the name, last name and email
                    let db = Firestore.firestore()
                    
                    db.collection("usuarios").addDocument(data: ["nombre":firstName, "apellido":lastName, "esAdmin": false, "correo": email, "contrasena":password, "uid": result!.user.uid]) { (error) in
                        
                        if error != nil {
                            
                            self.showError(title: "Error", message: "Los datos no pudieron guardarse.")
                        }
                    }
                    
                    //transition to home screen
                    let navigationMenu = self.storyboard?.instantiateViewController(identifier: "navigationMenu") as? NavController
                    
                    self.view.window?.rootViewController = navigationMenu
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
    
    func showError(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    //MARK: - KEYBOARD
    
    func registrarseParaNotificacionesDeTeclado() {
        NotificationCenter.default.addObserver(self, selector: #selector(tecladoSeMostro(aNotification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tecladoSeOculto(aNotification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @IBAction func quitKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func tecladoSeMostro(aNotification: NSNotification) {
        
        let kbSize = (aNotification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size
        
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        
        scrollView.setContentOffset(CGPoint(x: 0.0, y: activeField!.frame.origin.y - kbSize.height), animated: true)
    }
    
    @IBAction func tecladoSeOculto(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
}
