//
//  InformacionViewController.swift
//  Cultura-Visual
//
//  Created by user168625 on 5/9/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbNom: UILabel!
    @IBOutlet weak var lbAutor: UILabel!
    @IBOutlet weak var lbEdit: UILabel!
}

class InformacionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, administraMateriales {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vistaInfo: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barBtn: UIBarButtonItem!
    
    var listaMateriales = [Materiales]()
    var celdaMod : Int!
    var admin : Bool!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //navigationController?.navigationBar.barTintColor = Utilities.culturalOrange
        scrollView.contentSize = vistaInfo.frame.size
        llenarTabla()
        
        let user = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        
        db.collection("usuarios").whereField("uid", isEqualTo: user!).getDocuments{(snapshot, error) in
            
            if error == nil && snapshot != nil {
                
                for document in snapshot!.documents {
                    let documentData = document.data()
                    self.admin = documentData["esAdmin"] as? Bool ?? false
                }
            }
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            if !self.admin {
                self.navigationItem.rightBarButtonItem = nil
            }
            else {
                                          
                self.listaMateriales = []
                              
                let app = UIApplication.shared
                              
                NotificationCenter.default.addObserver(self, selector: #selector(self.guardarMateriales), name: UIApplication.didEnterBackgroundNotification, object: app)
                              
                if FileManager.default.fileExists(atPath: self.dataFileURL().path) {
                    self.obtenerMateriales()
                }
                    
            }
        }
    }
    
    /*Change the color of last view navbar to white
    override func viewWillDisappear(_ animated: Bool) {
        let viewController = navigationController?.viewControllers.first as! MainMenu
        viewController.navigationController?.navigationBar.barTintColor = UIColor.white
    }*/
    
    //MARK: - Table View
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 128
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return listaMateriales.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! CustomTableViewCell
            
            celda.lbNom.text = listaMateriales[indexPath.row].nombreLibro
            celda.lbAutor.text = listaMateriales[indexPath.row].autorLibro
            celda.lbEdit.text = listaMateriales[indexPath.row].editorLibro
            
            if !admin {
                celda.isUserInteractionEnabled = false
            }
            
            return celda
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if admin {
                
                let indexPath = tableView.indexPathForSelectedRow!
                celdaMod = indexPath.row
            }
        }
        
        // MARK: - Navigation

        func llenarTabla() -> Void {
        
            let db = Firestore.firestore()
                   
            db.collection("materiales").getDocuments{(snapshot, error) in
                              
                if error == nil && snapshot != nil {
                                  
                    for document in snapshot!.documents {
                        let documentData = document.data()
                        let nombre = documentData["nombre"] as! String
                        let autor = documentData["autor"] as! String
                        let edit = documentData["edicion/link"] as! String
                                       
                        let mat = Materiales(nombreLibro: nombre, autorLibro: autor, editorLibro: edit)
                        self.listaMateriales.append(mat)
                        self.tableView.reloadData()
                    }
                }
            }
        }
            
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
            if admin {
                    
                let vistaMat = segue.destination as! AgregarMaterialViewController
                     
                if segue.identifier == "agregar" {
                         
                    vistaMat.delegado = self
                }
                else {
                        
                    let indexPath = self.tableView.indexPathForSelectedRow!
                    vistaMat.mat = self.listaMateriales[indexPath.row]
                    vistaMat.acceder = false
                    vistaMat.delegado = self
                    
                }
            }
         }
        
        // MARK: - Protocolos
        
        func agregaMaterial(mat: Materiales) {
            listaMateriales.append(mat)
            tableView.reloadData()
        }
        
        func modificaMaterial(mat: Materiales) {
            listaMateriales[celdaMod].nombreLibro = mat.nombreLibro
            listaMateriales[celdaMod].autorLibro = mat.autorLibro
            listaMateriales[celdaMod].editorLibro = mat.editorLibro
            tableView.reloadData()
        }
        
        func eliminaMaterial() {
            listaMateriales.remove(at: celdaMod)
            tableView.reloadData()
        }

        //MARK: - Persistencia
        
        func dataFileURL() -> URL {
            
            let url = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
            let pathArchivo = url.appendingPathComponent("Materiales.plist")
            print(pathArchivo.path)
            return pathArchivo
            
        }
        
        @IBAction func guardarMateriales() {
               
               do {
                   let data = try PropertyListEncoder().encode(listaMateriales)
                   try data.write(to: dataFileURL())
               }
               catch {
                   print("Error al guardar los datos")
               }
           }
           
        func obtenerMateriales () {
               
               listaMateriales.removeAll()
               
               do {
                   let data = try Data.init(contentsOf: dataFileURL())
                   listaMateriales = try PropertyListDecoder().decode([Materiales].self, from: data)
               }
               catch {
                   print("Error al cargar los datos del archivo")
               }
               
               tableView.reloadData()
        }
}
