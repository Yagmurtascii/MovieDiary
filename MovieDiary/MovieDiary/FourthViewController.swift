//
//  FourthViewController.swift
//  ArtBook
//
//  Created by Yagmur on 21.07.2024.
//

import UIKit
import CoreData
class FourthViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

 
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var filmName: UITextField!
    @IBOutlet weak var director: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var year: UITextField!
    
    @IBOutlet weak var comment: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layer.cornerRadius = 5
        textView.layer.masksToBounds = true
        
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
        
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        image.addGestureRecognizer(imageTapRecognizer)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButton))
    }
    
    @objc func pickImage()
    {
        let pick = UIImagePickerController()
        pick.delegate = self
        pick.sourceType = .photoLibrary
        pick.allowsEditing = true
        present(pick, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButton()
    {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let newFilm = NSEntityDescription.insertNewObject(forEntityName: "Films", into: context)
        if(filmName.text != "" && director.text != "" && country.text != "" && year.text != "" && image.image != nil && comment.text != "")
        {
            newFilm.setValue(filmName.text, forKey: "filmName")
            newFilm.setValue(director.text, forKey: "director")
            newFilm.setValue(country.text, forKey: "country")
            if let newYear = Int(year.text!)
            {
                newFilm.setValue(newYear, forKey: "year")
            }
            newFilm.setValue(UUID().uuidString, forKey: "id")
            let data = image.image?.jpegData(compressionQuality: 0.5)
            newFilm.setValue(data, forKey: "image")
            newFilm.setValue(comment.text, forKey: "comment")
            do
            {
                try context.save()
                print("success")
            }catch{
                print("error")
            }
            
            NotificationCenter.default.post(name: NSNotification.Name("newFilm"), object: nil)
            performSegue(withIdentifier: "toListVC", sender: nil)
        }
        
        else
        {
            let alert = UIAlertController(title: "Warning", message: "This fields not empty", preferredStyle: UIAlertController.Style.alert)
            let button = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
            alert.addAction(button)
            self.present(alert, animated: true)
        }
        
    }
}
