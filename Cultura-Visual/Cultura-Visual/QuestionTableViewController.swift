//
//  QuestionTableViewController.swift
//  Cultura-Visual
//
//  Created by user168627 on 5/18/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit
import Firebase

class QuestionTableViewController: UITableViewController {

    let db = Firestore.firestore()
    let storage = Storage.storage()
    var questions = [Pregunta]()
    var images = [UIImage]()
    var pregImg:[Pregunta:UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        queryQuestions()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //Queries questions info
    func queryQuestions(){
        
        let defaultBoolArr = [false, false, false, false]
        let noData = Pregunta.NO_CONTENT
        let defaultStringArr = [noData, noData, noData, noData]
         db.collection("preguntas").getDocuments{(snapshot, error) in
            if error == nil && snapshot != nil {
                //Add each document fetched to the list
                for document in snapshot!.documents{
                    let documentData = document.data()
                    let tema = documentData["tema"] as! String
                    let preguntaTexto = documentData["preguntaTexto"] as? String ?? ""
                    let preguntaImagen = documentData["preguntaImagenUrl"] as? String ?? ""
                    //Form question and add it
                    let pregunta = Pregunta(tema: tema, preguntaTexto: preguntaTexto, preguntaImagen: preguntaImagen, respuestas: defaultStringArr, respSonTexto: defaultBoolArr, indexRespCorrecta: 0)
                    self.questions.append(pregunta)
                    //We are not fetching images right now
                    //Important not to put null because it will be as not adding anything
                    self.pregImg[pregunta] = UIImage()
                }
                //Start to fetch images in another thread
                self.loadQuestionsImages()
                //Update the table after fetching all the info
                self.tableView.reloadData()
            }}
    }
    
    //Queries the images of questions
    func loadQuestionsImages(){
        for (pregunta, _) in pregImg{
            //If there's an image question
            if (pregunta.preguntaImagen != nil && pregunta.preguntaImagen != ""){
                //Get the reference on fire storage
                let questionPathRef = storage.reference(withPath: pregunta.preguntaImagen)
                //Download the image of the reference
                questionPathRef.getData(maxSize: 1 * 1024 * 1024, completion: {data, error in
                    if error != nil {
                        print("Error downloading photo of question")
                    }
                    else {
                        //Get the data and form a UIImage with it
                        let imageQuestion = UIImage(data: data!)
                        //Save the image
                        self.pregImg[pregunta] = imageQuestion
                        //Reload tableview each time an image is fetched
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return questions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! QuestionTableViewCell
        let pregunta = questions[indexPath.row]
        //Get the image of the current question if it is not  null
        if let ivQuestion = pregImg[pregunta]{
            cell.ivQuestionImage.image = ivQuestion
        }
        
        //Assign the theme and title
        cell.lbTheme.text = pregunta.tema
        cell.lbQuestion.text = pregunta.preguntaTexto


        return cell
    }
    
    //return height of the cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 148
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}