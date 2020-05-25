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
    var menuOut = false
    
    
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
        

        // Do any additional setup after loading the view.
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
