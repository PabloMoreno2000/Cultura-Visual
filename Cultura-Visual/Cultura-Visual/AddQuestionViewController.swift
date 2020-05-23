//
//  AddQuestionViewController.swift
//  Cultura-Visual
//
//  Created by user168627 on 5/22/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit

class AddQuestionViewController: UIViewController, UITextViewDelegate{

    
    @IBOutlet weak var tvPregunta: UITextView!
    @IBOutlet weak var themePicker: UIPickerView!
    @IBOutlet weak var tvRespuesta: UITextView!
    @IBOutlet weak var ivRespuesta: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    var questionPlaceHolder = "Escriba aquí su pregunta"
    var answerPlaceHolder = "Escriba aquí la respuesta"
    //Array of possible images for the four answers
    var imageAnswers = [UIImage(), UIImage(), UIImage(), UIImage()]
    //Array of possible texts for the four answers
    var textAnswers = [String(), String(), String(), String()]
    //Current index of answer from 0 to 3
    var currentAnswer = 0
    
    @IBAction func indexAnswerChanged(_ sender: UISegmentedControl) {
        changeTextImage(index: segmentedControl.selectedSegmentIndex)
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
            imageAnswers[currentAnswer] = UIImage()
            ivRespuesta.image = UIImage(systemName: "photo.on.rectangle")
        //If it is an image
        case 1:
            //Show the image, hide the text view
            ivRespuesta.isHidden = false
            ivRespuesta.isUserInteractionEnabled = true
            tvRespuesta.isHidden = true
            tvRespuesta.isUserInteractionEnabled = false
            //Erase whatever could be inside the text for current answer
            textAnswers[currentAnswer] = String()
            //Needed to stop editing the text view
            tvRespuesta.resignFirstResponder()
            putPlaceHolder(placeHolder: answerPlaceHolder)
        default:
            break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //The scroll view should cover all the addView
        scrollView.contentSize = addView.frame.size
        //We need a delegate to edit text views
        tvPregunta.delegate = self
        tvRespuesta.delegate = self
        putPlaceHolder(placeHolder: answerPlaceHolder)
        putPlaceHolder(placeHolder: questionPlaceHolder)
        //Hide the image at the beginning
        changeTextImage(index: 0)
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //Empty any textview if it has placeholder
        if textView.textColor == UIColor.lightGray{
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //Just place placeholders if there's no text
        if textView.text.isEmpty{
            //If it is the text view of question text
            if textView == tvPregunta{
                textView.text = questionPlaceHolder
            }
            //if it is the text of the answer
            else {
                textView.text = answerPlaceHolder
            }
            
            //Put the text gray for any textview
            textView.textColor = UIColor.lightGray
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
