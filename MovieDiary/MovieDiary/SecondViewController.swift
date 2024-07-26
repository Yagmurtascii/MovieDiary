import UIKit
import CoreData

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var filmName = [String]()
    var id = [String]()
    var choosenId: String?
    var choosenFilmName = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        getData()
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newFilm"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//   let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        var content = cell.defaultContentConfiguration()
        content.text = filmName[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < id.count {
            choosenId = id[indexPath.row]
         
            performSegue(withIdentifier: "toThirdVC", sender: nil)
            } else {
                print("Selected index is out of range for id array")
            }
        
    }
    
    @objc func getData() {
        filmName.removeAll()
       
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Films")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    print(result.objectID)
                    if let name = result.value(forKey: "filmName") as? String {
                        self.filmName.append(name)
                    }
                    if let i = result.value(forKey: "id") as? String {
                        self.id.append((i))
                 
                    }
                }
             
                print("filmName: \(filmName)")
                print("id: \(id)")
                self.tableView.reloadData()
            }
        } catch {
          
            print("error")
        }
    }
    
    @objc func addButton() {
        performSegue(withIdentifier: "toAddVC", sender: nil)
    }
    
    @objc func editButton() {
        performSegue(withIdentifier: "toAddVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toThirdVC" {
            let destinationVC = segue.destination as! ThirdViewController
            destinationVC.selectedId = choosenId
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let app = UIApplication.shared.delegate as! AppDelegate
            let context = app.persistentContainer.viewContext
            
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Films")
            let idString = id[indexPath.row]
            
            fetch.predicate = NSPredicate(format: "id = %@", idString)
            
            do {
                let result = try context.fetch(fetch)
                if result.count > 0
                {
                    for r in result as! [NSManagedObject] {
                        if let i = r.value(forKey: "id") as? String
                        {
                            if i == id[indexPath.row]
                            {
                                context.delete(r)
                                filmName.remove(at: indexPath.row)
                                id.remove(at: indexPath.row)
                                self.tableView.reloadData()
                                do{
                                    try context.save()
                                }catch
                                {
                                    print("error")
                                }
                                break
                    

                            }
                        }
                    }
                }
            }
            catch{
                print("error")
            }
            
        }
        
    }
    
   
}
