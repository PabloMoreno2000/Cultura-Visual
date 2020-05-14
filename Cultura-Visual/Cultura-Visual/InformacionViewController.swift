//
//  InformacionViewController.swift
//  Cultura-Visual
//
//  Created by user168625 on 5/9/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbNom: UILabel!
    @IBOutlet weak var lbAutor: UILabel!
    @IBOutlet weak var lbEdit: UILabel!
}

class InformacionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, administraMateriales {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vistaInfo: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var listaMateriales = [Materiales]()
    var celdaMod : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = vistaInfo.frame.size
        
        tableView.delegate = self
        tableView.dataSource = self
        
        listaMateriales = []
               
        let app = UIApplication.shared
               
        NotificationCenter.default.addObserver(self, selector: #selector(guardarMateriales), name: UIApplication.didEnterBackgroundNotification, object: app)
               
        if FileManager.default.fileExists(atPath: dataFileURL().path) {
            obtenerMateriales()
        }
    }
    
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
            
            return celda
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let indexPath = tableView.indexPathForSelectedRow!
            celdaMod = indexPath.row
            
        }
        
        // MARK: - Navigation

         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             
             let vistaMat = segue.destination as! AgregarMaterialViewController
             
             if segue.identifier == "agregar" {
                 
                 vistaMat.delegado = self
             }
             else {
                 let indexPath = tableView.indexPathForSelectedRow!
                 vistaMat.mat = listaMateriales[indexPath.row]
                 vistaMat.acceder = false
                 vistaMat.delegado = self
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
