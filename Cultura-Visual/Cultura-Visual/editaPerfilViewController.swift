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
    @IBOutlet weak var lbCorreo: UILabel!
    
    var nombreCurrent: String!
    var apellidoCurrent: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = Utilities.culturalOrange
        cargarDatos()
    }
    
    //Change the color of last view navbar to white
    override func viewWillDisappear(_ animated: Bool) {
        let viewController = navigationController?.viewControllers.first as! MainMenu
        viewController.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    @IBAction func btEditar(_ sender: UIButton) {
        
        if (nombreCurrent != tfNombre.text || apellidoCurrent != tfApellido.text) {
            
            let user = Auth.auth().currentUser?.uid
            let db = Firestore.firestore()
            
            db.collection("usuarios").whereField("uid", isEqualTo: user!).getDocuments{(snapshot, error) in
            
                if error == nil && snapshot != nil {
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        
                        //updates data of the document
                        db.collection("usuarios").document(documentID).setData(["nombre": self.tfNombre.text, "apellido": self.tfApellido.text], merge: true) { (error) in
                            
                            if error != nil {
                                
                                self.showError(title: "Error", message: "El nombre no pudo actualizarse.")
                            }
                            else {
                                let alert = UIAlertController(title: "Hecho!", message: "Se han guardado los cambios", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                self.nombreCurrent = self.tfNombre.text
                                self.apellidoCurrent = self.tfApellido.text
                            }
                        }
                    }
                }
            }
        }
        else {
            
            let alert = UIAlertController(title: "Sin cambios", message: "No hay cambios que registrar", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btContra(_ sender: UIButton) {
    }
    
    func cargarDatos() {
        
        let user = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        
        db.collection("usuarios").whereField("uid", isEqualTo: user!).getDocuments{(snapshot, error) in
        
            if error == nil && snapshot != nil {
                for document in snapshot!.documents {
                    let documentData = document.data()
                    let nombre = documentData["nombre"] as? String ?? ""
                    let apellido = documentData["apellido"] as? String ?? ""
                    let correo = documentData["correo"] as? String ?? ""
                    self.tfNombre.text = nombre
                    self.tfApellido.text = apellido
                    self.lbCorreo.text = correo
                    self.nombreCurrent = nombre
                    self.apellidoCurrent = apellido
                }
            }
        }
    }
    
    func showError(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }

}
