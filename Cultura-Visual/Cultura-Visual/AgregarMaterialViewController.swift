//
//  AgregarMaterialViewController.swift
//  Cultura-Visual
//
//  Created by user168625 on 5/13/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !acceder {
            
            btnCambio.setTitle("Modificar", for: .normal)
            tfNombreLib.text = mat.nombreLibro
            tfAutorLib.text = mat.autorLibro
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
            
            if acceder {
                delegado.agregaMaterial(mat: mater)
                navigationController?.popViewController(animated: true)
            }
            else {
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

}
