//
//  MainMenu.swift
//  Cultura-Visual
//
//  Created by user168627 on 4/8/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit

import Firebase

class MainMenu: UIViewController {

    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var menuHam: UIView!
    @IBOutlet weak var adminButton: UIButton!
    @IBOutlet weak var lbNombre: UILabel!
    
    var menuOut = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Lineas para esconder, y dar sombra a la view de hamburguesa
        menuHam.isHidden = true
        menuHam.alpha = 0
        menuHam.layer.shadowColor = UIColor.black.cgColor
        menuHam.layer.shadowOpacity = 1
        menuHam.layer.shadowOffset = .zero
        menuHam.layer.shadowRadius = 10
        
        //Linea para que no se haga render de la sombra cada vez
        menuHam.layer.shadowPath = UIBezierPath(rect: menuHam.bounds).cgPath
        manageAdminButton()
        
        let user = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        
        db.collection("usuarios").whereField("uid", isEqualTo: user!).getDocuments{(snapshot, error) in
        
            if error == nil && snapshot != nil {
                for document in snapshot!.documents {
                    let documentData = document.data()
                    let nombre = documentData["nombre"] as? String ?? ""
                    self.lbNombre.text = nombre
                }
            }
        }
    }
    
    //boton hamburguesa, que despliega un mini menu donde el usuario puede editar su perfil, o terminar sesion
    @IBAction func hambutton(_ sender: UIBarButtonItem) {
        
        if(menuHam.isHidden){
            abrirMenuHam()
        }
        else{
            cerrarMenuHam()
        }
        
        /*
        //asi estaba la funcion cuando le pedia que hiciera slide para el hamburger menu
        if menuOut == false{
            leading.constant = 150
            trailing.constant = -150
            menuOut = true
        }
        else {
            leading.constant = 0
            trailing.constant = 0
            menuOut = false
        }
        UIView.animate(withDuration: 0.2, delay : 0.0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()})
         */
    }
    
    //funcion para abrir el menu
    func abrirMenuHam(){
        menuHam.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.menuHam.alpha = 1
        })
    }
    
    //funcion para cerrar el menu
    func cerrarMenuHam(){
        UIView.animate(withDuration: 0.5, animations: {
            self.menuHam.alpha = 0
        }, completion: {finished in
            self.menuHam.isHidden = true
        })
    }
    
    //el boton invoca la alerta antes de salir de sesion
    @IBAction func logoutbutton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Aviso", message: "Estas a punto de cerrar sesion", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Salir", style: .destructive, handler: { action in
            self.logout()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    //funcion que termina la sesion del usuario, y regresa a la pantalla principal
    func logout(){
        let firebaseAuth = Auth.auth()
              do {
        
                  try firebaseAuth.signOut()
                  let signInScreen = self.storyboard?.instantiateViewController(identifier: "signIn") as? ViewController
                  
                  self.view.window?.rootViewController = signInScreen
                  self.view.window?.makeKeyAndVisible()

              } catch let signOutError as NSError {
        
                  print ("Error signing out: %@", signOutError)

              }
    }
    
    func manageAdminButton() {
        //Hide the admin button
        adminButton.isUserInteractionEnabled = false
        adminButton.isHidden = true
        
        let user = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        //And just show it if user is an admin
        db.collection("usuarios").whereField("uid", isEqualTo: user!).getDocuments{(snapshot, error) in
            if error == nil && snapshot != nil {
                
                for document in snapshot!.documents {
                    let documentData = document.data()
                    let isAdmin = documentData["esAdmin"] as? Bool ?? false
                    if isAdmin {
                        self.adminButton.isUserInteractionEnabled = true
                        self.adminButton.isHidden = false
                    }
                }
            }
        }
    }
}
