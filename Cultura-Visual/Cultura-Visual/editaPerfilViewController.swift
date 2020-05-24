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
    var nombreCurrent: String!
    var apellidoCurrent: String!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cargarDatos()
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
        if (nombreCurrent != tfNombre.text || apellidoCurrent != tfApellido.text){
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
                            else{
                                let alert = UIAlertController(title: "Hecho!", message: "Se han guardado los cambios", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                self.nombreCurrent = self.tfNombre.text
                                self.apellidoCurrent = self.tfApellido.text
                            }
                        }                }
                }
            }

        }
        else{
            let alert = UIAlertController(title: "Sin cambios", message: "No hay cambios que registrar", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    @IBAction func btContra(_ sender: UIButton) {
    }
    
    
    func cargarDatos(){
        let user = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        
        db.collection("usuarios").whereField("uid", isEqualTo: user!).getDocuments{(snapshot, error) in
        
            if error == nil && snapshot != nil {
                for document in snapshot!.documents {
                    let documentData = document.data()
                    let nombre = documentData["nombre"] as? String ?? ""
                    let apellido = documentData["apellido"] as? String ?? ""
                    self.tfNombre.text = nombre
                    self.tfApellido.text = apellido
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
