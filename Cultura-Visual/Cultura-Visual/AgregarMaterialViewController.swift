//
//  AgregarMaterialViewController.swift
//  Cultura-Visual
//
//  Created by user168625 on 5/13/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

protocol administraMateriales {
    func agregaMaterial (mat : Materiales) -> Void
    func modificaMaterial(mat : Materiales) -> Void
    func eliminaMaterial() -> Void
}

class AgregarMaterialViewController: UIViewController {

    @IBOutlet weak var tfNombreLib: UITextField!
    @IBOutlet weak var tfAutorLib: UITextField!
    @IBOutlet weak var tfEdicionLib: UITextField!
    
    @IBOutlet weak var btnCambio: UIButton!
    @IBOutlet weak var btnEliminar: UIButton!
    
    var delegado : administraMateriales!
    var mat : Materiales!
    var acceder = true
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !acceder {
            
            btnCambio.setTitle("Modificar", for: .normal)
            tfNombreLib.text = mat.nombreLibro
            tfNombreLib.isUserInteractionEnabled = false
            tfAutorLib.text = mat.autorLibro
            tfAutorLib.isUserInteractionEnabled = false
            tfEdicionLib.text = mat.editorLibro
            btnEliminar.isHidden = false
            
        }
        else {
            
            btnCambio.setTitle("Agregar", for: .normal)
            btnEliminar.isHidden = true
            
        }
    }
    
    @IBAction func btnCambiar(_ sender: Any) {
        
        if tfNombreLib.text != "" && tfAutorLib.text != "" && tfEdicionLib.text != "" {
        
            let nom = tfNombreLib.text!
            let aut = tfAutorLib.text!
            let ed = tfEdicionLib.text!
        
            let mater = Materiales(nombreLibro: nom, autorLibro: aut, editorLibro: ed)
            
            let uid = Auth.auth().currentUser?.uid
            let db = Firestore.firestore()
            
            if acceder {
                
                delegado.agregaMaterial(mat: mater)
                
                db.collection("materiales").addDocument(data: ["nombre": nom, "autor": aut, "edicion/link": ed, "userID": uid!]) {(error) in
                    
                    if error != nil {
                        
                        self.showError(title: "Error", message: "Los datos no pudieron guardarse.")
                    }
                }
                
                navigationController?.popViewController(animated: true)
            
            }
            else {
                
                db.collection("materiales").whereField("nombre", isEqualTo: nom).getDocuments{(snapshot, error) in
                    
                    if error == nil {
                        //if the document exists
                        if snapshot != nil && snapshot!.count > 0 {
                           
                            for document in snapshot!.documents {
                                //get its ID
                                let documentID = document.documentID
                                
                                //updates data of the document
                                db.collection("materiales").document(documentID).setData(["edicion/link": ed], merge: true) { (error) in
                                    
                                    if error != nil {
                                        
                                        self.showError(title: "Error", message: "Los datos no pudieron actualizarse.")
                                    }
                                }
                            }
                        }
                    }
                }
                
                delegado.modificaMaterial(mat: mater)
                navigationController?.popViewController(animated: true)
            }
        }
        
        else {
            
            let alerta = UIAlertController(title: "Aviso", message: "Todos los campos deben ser llenados", preferredStyle: .alert)
            
            let accion = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alerta.addAction(accion)
            
            present(alerta, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnEliminar(_ sender: Any) {
        
        let alerta = UIAlertController(title: "Aviso", message: "¿Estás seguro de que deseas eliminar este material?", preferredStyle: .alert)
        
        let accionE =  UIAlertAction(title: "Eliminar", style: .default, handler: {(action) in
            
            self.delegado.eliminaMaterial()
            
            let db = Firestore.firestore()
            
            db.collection("materiales").whereField("nombre", isEqualTo: self.tfNombreLib.text!).getDocuments{(snapshot, error) in
                
                    if error == nil && snapshot != nil {
                        for document in snapshot!.documents {
                            document.reference.delete()
                    }

                }
            }
            
            self.navigationController?.popViewController(animated: true)
        })
        let accionC = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alerta.addAction(accionE)
        alerta.addAction(accionC)
        
        present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func quitKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func showError(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }

}
