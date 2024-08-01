//
//  ThirdViewController.swift
//  ArtBook
//
//  Created by Yagmur on 21.07.2024.
//

import UIKit
import CoreData
import AlertLib
class ThirdViewController: UIViewController {

    
    @IBOutlet weak var filmName: UILabel!
    @IBOutlet weak var director: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    var selectedId : String?
    var selectedFilmName = ""
    var selectedDirector = ""
    var selectedYear : Int32 = 0
    var selectedCountry = ""
    var selectedComment = ""
    var selectedImage = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Films")
        
        let id = selectedId!
        print(id)

        
        fetch.predicate = NSPredicate(format: "id = %@", id)
        fetch.returnsObjectsAsFaults = false
        
        
        do
        {
            let result = try context.fetch(fetch)
            if result.count > 0
            {
                for r in result as! [NSManagedObject]
                {
                    if let newFilmName = r.value(forKey: "filmName") as? String
                    {
                        filmName.text = newFilmName
                    }
                     
                    if let newDirector = r.value(forKey: "director") as? String
                    {
                        director.text = newDirector
                    }
                    
                    if let newCountry = r.value(forKey: "country") as? String
                    {
                        country.text = newCountry
                    }
                    
                    if let newYear = r.value(forKey: "year") as? String
                    {
                        year.text = newYear
                    }
                    
                    if let newComment = r.value(forKey: "comment") as? String
                    {
                        comment.text = newComment
                    }
                    
                    if let newImage = r.value(forKey: "image") as? Data
                    {
                        let imageView = UIImage(data: newImage)
                        image.image = imageView
                    }
                }
            }
            else
            {
                AlertLib.showSingleButtonAlert(on: self, alertTitle: "Warning", buttonTitle: "Ok", message: "No data available", actionAlertType: ActionAlertType.defaultType, controllerAlertType: ControllerAlertType.alert)
            }
        }
        catch
        {
            print("error")
        }
        
        
        
        
        // Do any additional setup after loading the view.
    }
    

}
