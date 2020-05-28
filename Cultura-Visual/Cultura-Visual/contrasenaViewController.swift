//
//  contrasenaViewController.swift
//  Cultura-Visual
//
//  Created by user168641 on 5/9/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit
import Firebase

class contrasenaViewController: UIViewController {

    @IBOutlet weak var tfActual: UITextField!
    @IBOutlet weak var tfNueva: UITextField!
    @IBOutlet weak var tfConfirma: UITextField!
    
    var passwordCurrent: String!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = Utilities.culturalOrange
        cargarDatos()
        
    }

    
    @IBAction func btGuardar(_ sender: UIButton) {
        
        if (passwordCurrent != tfActual.text) {
            let alert = UIAlertController(title: "Error!", message: "Contrasena actual incorrecta", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
            
        else if(isPasswordValide(password: tfNueva.text!) == false) {
            let alert = UIAlertController(title: "Error!", message: "Tu contraseña debe tener 8 caracteres incluyendo un caracter especial y un número", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
        else if(tfNueva.text != tfConfirma.text) {
            let alert = UIAlertController(title: "Error!", message: "No coincide la contrasena nueva", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        else {
                let user = Auth.auth().currentUser?.uid
                let db = Firestore.firestore()
                
                db.collection("usuarios").whereField("uid", isEqualTo: user!).getDocuments{(snapshot, error) in
                
                    if error == nil && snapshot != nil {
                        for document in snapshot!.documents {
                            let documentID = document.documentID
                            
                            //updates data of the document
                            Auth.auth().currentUser?.updatePassword(to: self.tfNueva.text ?? "")
                            db.collection("usuarios").document(documentID).setData(["contrasena": self.tfNueva.text], merge: true) { (error) in
                                
                                if error != nil {
                                    
                                    self.showError(title: "Error", message: "El nombre no pudo actualizarse.")
                                }
                                else{
                                    let alert = UIAlertController(title: "Hecho!", message: "Se han guardado los cambios", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    self.passwordCurrent = self.tfNueva.text
                                }
                            }
                        }
                    }
                }
            }
    }
    
    func cargarDatos(){
        let user = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        
        db.collection("usuarios").whereField("uid", isEqualTo: user!).getDocuments{(snapshot, error) in
        
            if error == nil && snapshot != nil {
                for document in snapshot!.documents {
                    let documentData = document.data()
                    let pass = documentData["contrasena"] as? String ?? ""
                    self.passwordCurrent = pass
                    
                }
            }
        }
    }
    
    func showError(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }

    func isPasswordValide(password : String) -> Bool {
    
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    @IBAction func quitKeyboard(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
    }
    

}
