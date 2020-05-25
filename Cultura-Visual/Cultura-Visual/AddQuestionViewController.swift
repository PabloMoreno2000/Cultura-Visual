//
//  AddQuestionViewController.swift
//  Cultura-Visual
//
//  Created by user168627 on 5/22/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit
import Firebase

class AddQuestionViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var tvPregunta: UITextView!
    @IBOutlet weak var themePicker: UIPickerView!
    @IBOutlet weak var tvRespuesta: UITextView!
    @IBOutlet weak var ivRespuesta: UIImageView!
    @IBOutlet weak var ivQuestion: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var lbRespuesta: UILabel!
    @IBOutlet weak var tfRespCorrecta: UITextField!
    @IBOutlet weak var bAddQuestion: UIButton!
    
    
    var questionPlaceHolder = "Escriba aquí su pregunta"
    var answerPlaceHolder = "Escriba aquí la respuesta"
    //Array of possible images for the four answers
    var imageAnswers: [UIImage] = []
    //Array of possible texts for the four answers
    var textAnswers = [String(), String(), String(), String()]
    //Current index of answer from 0 to 3
    var currentAnswer = 0
    let placeHolderImage = UIImage(systemName: "photo.on.rectangle")
    //0 if last image clicked was question, 1 if answer
    var lastImage = 0
    //Data for the picker view
    let pickerData = Cuestionario.themes
    //To check if the question image was inserted
    var hasQuestionImage = false
    //Just the first time the text of the answer textview will be removed(placeholder)
    var removeTextAnswer = true
    //Reference to firebase storage
    let storageRef = Storage.storage().reference()
    
    //MARK: PickerView methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    // MARK: Camera methods
    @IBAction func tapQuestionImage(_ sender: UITapGestureRecognizer) {
        lastImage = 0
        addPhoto()
    }
    
    @IBAction func tapAnswerImage(_ sender: UITapGestureRecognizer) {
        lastImage = 1
        addPhoto()
    }
    
    func addPhoto(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    //Si el usuario eligió una foto
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let foto = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        //If it was the question image
        if lastImage == 0{
            ivQuestion.image = foto
            hasQuestionImage = true
        }
        //If it was the question
        else if lastImage == 1{
            ivRespuesta.image = foto
            //Add the photo to the array
            imageAnswers[currentAnswer] = foto
        }
        //dismiss the picker controller
        dismiss(animated: true, completion: nil)
    }
    
    //If the user cancels the image selection just dismiss picker controller
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Check & upload question
    //Button that must be clicked to add question (not just an image)
        @IBAction func addImage(_ sender: UIButton) {
        //Deactive user interaction with this button
        bAddQuestion.isUserInteractionEnabled = false
            
        //Counter of answers with image
        var imageAnsCount = 0
        //Counter of answers with text
        var textAnsCount = 0
        var errorMessage = "Falta: "
        var thereIsError = false
        
        //Variables to store question info
        var indexRespCorrecta = 0
        var preguntaImagenUrl = ""
        var preguntaTexto = ""
        //Pickerview always have something selected
        var tema = pickerData[themePicker.selectedRow(inComponent: 0)]
        var respSonTexto = [true, true, true, true]
        var respuestas = ["", "", "", ""]
        var hasImageQuestion = false
    
        
        //Save info of current question (text could be possibly not saved)
        saveCurrentInfo()
        
        //check for a question image
        //For a certain reason it's not enough with areImagesEqual
        if(!areImagesEqual(image1: ivQuestion.image!, isEqualTo: placeHolderImage!) && hasQuestionImage){
            hasImageQuestion = true
        }
        
        //check for a question text
        if(tvPregunta.text != nil && (tvPregunta.text != questionPlaceHolder && Utilities.cleanString(s: tvPregunta.text) != "")){
            preguntaTexto = tvPregunta.text
        }
        
        //There is an error if no question image and/or text are given
        if(preguntaTexto == "" && !hasImageQuestion){
            thereIsError = true
            errorMessage += "pregunta imagen/texto, "
        }
        
        //check that there's data for each question
        //count the imaged-answers
        for i in 0...imageAnswers.count-1{
            let image = imageAnswers[i]
            if(!areImagesEqual(image1: image, isEqualTo: placeHolderImage!)){
                imageAnsCount += 1
                respSonTexto[i] = false
            }
        }
        
        //count the textual answers
        for i in 0...textAnswers.count-1{
            let text = textAnswers[i]
            if (text != "" && text != answerPlaceHolder){
                textAnsCount += 1
                respuestas[i] = text
            }
        }
        
        if(textAnsCount + imageAnsCount < 4){
            thereIsError = true
            errorMessage += String(4 - textAnsCount - imageAnsCount) + " respuestas, "
        }
        
        //Check if an index for the right answer is right and given
        if let givenAns = tfRespCorrecta.text{
            if let givenIndex = Int(givenAns){
                if givenIndex >= 1 && givenIndex <= 4{
                    //Count from 0
                    indexRespCorrecta = givenIndex - 1
                }
                else {
                    thereIsError = true
                    errorMessage += "índice numérico de resp. entre 1 y 4, "
                }
            }
            else {
                thereIsError = true
                errorMessage += "índice numérico de resp. correcta, "
            }
        }
        else {
            thereIsError = true
            errorMessage += "resp. correcta, "
        }
        
        //If there's no error submit the question to database
        if(!thereIsError){
            //If there is an image
            if hasImageQuestion{
                // Data in memory
                let data = ivQuestion.image?.jpegData(compressionQuality: 0.4)

                // Create a reference to the file you want to upload
                //Just to generate a unique string
                let time = String(Int(100000*NSDate().timeIntervalSince1970))
                let imagePath = tema + "/" + time + ".jpg"
                let imageRef = storageRef.child(imagePath)

                // Upload the file to the path "images/rivers.jpg"
                let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
                  guard let metadata = metadata else {
                    //Send error message to user
                    self.showAlertMessage(title: "Error", message: "No se pudo subir la imagen de la pregunta. Intente más tarde")
                    //Allow the user to make other try
                    self.bAddQuestion.isUserInteractionEnabled = true
                    // Uh-oh, an error occurred!
                    return
                  }
                  // Metadata contains file metadata such as size, content-type.
                  let size = metadata.size
                  // You can also access to download URL after upload.
                  imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        //Send error message to user
                        self.showAlertMessage(title: "Error", message: "No se pudo subir la imagen de la pregunta. Intente más tarde")
                        self.bAddQuestion.isUserInteractionEnabled = true
                      // Uh-oh, an error occurred!
                      return
                    }
                    //save the url. I could use downloadURL if I wanted an https link
                    preguntaImagenUrl = imagePath
                    
                    //upload the question after getting the question image
                    self.uploadQuestion(hasText: respSonTexto, currentIndex: respSonTexto.count - 1, theme: tema, respuestas: respuestas, preguntaImagenUrl: preguntaImagenUrl, respCorrecta: indexRespCorrecta, preguntaTexto: preguntaTexto)
                  }
                }
            }
            //If it doesn't has a question image
            else {
                //Just upload the question
                //upload the question after getting the question image
                self.uploadQuestion(hasText: respSonTexto, currentIndex: respSonTexto.count - 1, theme: tema, respuestas: respuestas, preguntaImagenUrl: preguntaImagenUrl, respCorrecta: indexRespCorrecta, preguntaTexto: preguntaTexto)
            }
        }
        //Else display the error message
        else {
            //Allow user interaction with add question button
            bAddQuestion.isUserInteractionEnabled = true
            //Delete the last ", " part
            errorMessage = (errorMessage as NSString).substring(to: errorMessage.count - 2)
            showAlertMessage(title: "Datos faltantes", message: errorMessage)
        }
    }
    
    //Recursive function that uploads the images of imageAnswer given a true/false array of the same length
    //Current index is judge.count-1 in the first call
    //Theme is the theme of the question being upload
    //respuestas -> string array of answers
    func uploadQuestion(hasText: [Bool], currentIndex: Int, theme: String, respuestas:[String], preguntaImagenUrl: String, respCorrecta: Int, preguntaTexto: String){
        var newResp = respuestas
        //If current index hasn't an image, check the rest
        if currentIndex >= 0 && hasText[currentIndex] {
            uploadQuestion(hasText: hasText, currentIndex: currentIndex - 1, theme: theme, respuestas: newResp, preguntaImagenUrl: preguntaImagenUrl, respCorrecta: respCorrecta, preguntaTexto: preguntaTexto)
        }
        //If current index has image
        else if currentIndex >= 0 && !hasText[currentIndex] {
            // Data in memory
            let data = imageAnswers[currentIndex].jpegData(compressionQuality: 0.4)

            // Create a reference to the file you want to upload
            //Just to generate a unique string
            let time = String(Int(100000*NSDate().timeIntervalSince1970))
            let imagePath = theme + "/" + time + ".jpg"
            let imageRef = storageRef.child(imagePath)

            // Upload the file to the path "images/rivers.jpg"
            let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
              guard let metadata = metadata else {
                //Send error message to user
                self.showAlertMessage(title: "Error", message: "No se pudo subir la imagen de la respuesta " + String(currentIndex + 1) + ". Intente más tarde")
                //Allow user interaction again
                self.bAddQuestion.isUserInteractionEnabled = true
                // Uh-oh, an error occurred!
                return
              }
              // Metadata contains file metadata such as size, content-type.
              let size = metadata.size
              // You can also access to download URL after upload.
              imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    //Send error message to user
                self.showAlertMessage(title: "Error", message: "No se pudo subir la imagen de la respuesta " + String(currentIndex + 1) + ". Intente más tarde")
                //Allow user interaction again
                self.bAddQuestion.isUserInteractionEnabled = true
                // Uh-oh, an error occurred!
                  return
                }
                //save the url, I could use downloadURL.absoluteString if I needed a https link
                newResp[currentIndex] = imagePath
                //go to the next recursive call
                self.uploadQuestion(hasText: hasText, currentIndex: currentIndex - 1, theme: theme, respuestas: newResp, preguntaImagenUrl: preguntaImagenUrl, respCorrecta: respCorrecta, preguntaTexto: preguntaTexto)
              }
            }
        }
        //Else currentIndex is less than 0(images are uploaded), create the colection on firestore
        else {
            let db = Firestore.firestore()
            db.collection("preguntas").addDocument(data: ["indexRespCorrecta": respCorrecta, "preguntaImagenUrl": preguntaImagenUrl, "preguntaTexto": preguntaTexto, "respSonTexto": hasText, "respuestas": respuestas, "tema":theme]) {(error) in
                //After uploading the info, if there is no error
                if error == nil {
                    //Go to question-list screen
                    self.navigationController?.popViewController(animated: true)
                }
                //If there is error
                else {
                    //report to the user
                    self.showAlertMessage(title: "Error", message: "No se pudo crear la pregunta. Intente más tarde.")
                    //Allow user interaction again
                    self.bAddQuestion.isUserInteractionEnabled = true
                }
            }
        }
        
    }
    
    @IBAction func indexAnswerChanged(_ sender: UISegmentedControl) {
        changeTextImage(index: segmentedControl.selectedSegmentIndex)
    }
    
    @IBAction func leftArrowTap(_ sender: UIButton) {
        moveAnswerPos(delta: -1)
    }
    
    @IBAction func rightArrowTap(_ sender: UIButton) {
        moveAnswerPos(delta: 1)
    }
    
    //Delta should always be -1(left) or 1(right)
    func moveAnswerPos(delta: Int){
        let newIndex = delta + currentAnswer
        //We just have two answers
        if(newIndex >= 0 && newIndex <= 3){
            //Save the data of the current answer
            saveCurrentInfo()
            //Update the reference variable
            currentAnswer = newIndex
            
            //Update the info for the user
            lbRespuesta.text = "Respuesta " + String(currentAnswer + 1)
            ivRespuesta.image = imageAnswers[currentAnswer]
            tvRespuesta.text = textAnswers[currentAnswer]
            
            //Update the segmentedControl, remember that just one (text or image) has content, and there's a placeholder image
            if(areImagesEqual(image1: placeHolderImage!, isEqualTo: ivRespuesta.image!)){
                segmentedControl.selectedSegmentIndex = 0
                //hide the image
                changeTextImage(index: 0)
            }
            else{
                segmentedControl.selectedSegmentIndex = 1
                //hide the text
                changeTextImage(index: 1)
            }
        }
    }
    
    //Saves info of current question
    func saveCurrentInfo() {
        textAnswers[currentAnswer] = tvRespuesta.text
        imageAnswers[currentAnswer] = ivRespuesta.image ?? UIImage()
    }
    
    func changeTextImage(index: Int){
        switch segmentedControl.selectedSegmentIndex{
        //If it is text
        case 0:
            //Show the text view, hide the image
            tvRespuesta.isHidden = false
            tvRespuesta.isUserInteractionEnabled = true
            ivRespuesta.isHidden = true
            ivRespuesta.isUserInteractionEnabled = false
            //Erase whatever could be inside the image for current answer
            imageAnswers[currentAnswer] = placeHolderImage!
            ivRespuesta.image = placeHolderImage
        //If it is an image
        case 1:
            //Show the image, hide the text view
            ivRespuesta.isHidden = false
            ivRespuesta.isUserInteractionEnabled = true
            tvRespuesta.isHidden = true
            tvRespuesta.isUserInteractionEnabled = false
            //Erase whatever could be inside the text for current answer
            textAnswers[currentAnswer] = String()
            tvRespuesta.text = ""
            //Needed to stop editing the text view
            tvRespuesta.resignFirstResponder()
            //putPlaceHolder(placeHolder: answerPlaceHolder)
        default:
            break
        }
    }
    
    
func areImagesEqual(image1: UIImage, isEqualTo image2: UIImage) -> Bool {
    let data1: NSData = image1.pngData()! as NSData
    let data2: NSData = image2.pngData()! as NSData
    return data1.isEqual(data2)
}
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize variables
        imageAnswers = [placeHolderImage!, placeHolderImage!, placeHolderImage!, placeHolderImage!]
        //Connecting data of picker view
        self.themePicker.delegate = self
        self.themePicker.dataSource = self
        //The scroll view should cover all the addView
        scrollView.contentSize = addView.frame.size
        //We need a delegate to edit text views
        tvPregunta.delegate = self
        tvRespuesta.delegate = self
        putPlaceHolder(placeHolder: answerPlaceHolder)
        putPlaceHolder(placeHolder: questionPlaceHolder)
        //Hide the image at the beginning
        changeTextImage(index: 0)
    }
    
    //Function to show an error message
    func showAlertMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == questionPlaceHolder{
            tvPregunta.textColor = UIColor.black
            tvPregunta.text = ""
        }
        //Empty any textview if it has placeholder
        else if removeTextAnswer{
            tvRespuesta.textColor = UIColor.black
            tvRespuesta.text = ""
            textAnswers[currentAnswer] = ""
            //Don't remove text after removing placeholder
            removeTextAnswer = false
        }
    }

    func putPlaceHolder(placeHolder : String){
        if placeHolder == questionPlaceHolder{
            tvPregunta.text = questionPlaceHolder
            tvPregunta.textColor = UIColor.lightGray
        }
        //else it should be the the answer placeholder
        else {
            tvRespuesta.text = answerPlaceHolder
            tvRespuesta.textColor = UIColor.lightGray
        }
    }
}
