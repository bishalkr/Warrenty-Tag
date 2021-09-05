//
//  ItemViewController.swift
//  Warrenty Tag
//
//  Created by Bishal kumar  on 26/08/21.
//


import UIKit
import Firebase

class ItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    let db = Firestore.firestore()
    var selectedCategory : Category?
    @IBOutlet weak var tableView: UITableView!
    var itemsAdded: [ItemsAdded] = []
    var dateFormatter = DateFormatter()
   
    var currentDate = Date()
   
    var selectedItem: String?
    var totalDaysLeft: Int?
    var progressBarStatus: Float?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadtableView()
        
        tableView.register(UINib(nibName: "ItemViewCell", bundle: nil), forCellReuseIdentifier:"itemCell")
        
        
    }
    
    
    func loadtableView()
    {
        let user = Auth.auth().currentUser
        if let user = user
        {
            let userID = user.uid
            db.collection("users/\(userID)/\(selectedCategory!.categoryTitle!)").addSnapshotListener{ (querySnapShot, error) in
                
                self.itemsAdded = []
        
                if let e = error
                {
                   
                    print("Error while loading the data - \(e.localizedDescription)")
                }
                else
                {
                  
                   if let snapShotDocuments = querySnapShot?.documents
                   {
                    for doc in snapShotDocuments
                    {
                        let data = doc.data()
                        
                        if let itemName = data["Name"] as? String, let willExpire = data["Will Expire on"] as? String, let daysLeft = data["Days Left"] as? Int
                        {  self.dateFormatter.dateFormat = "dd/MM/yy"
                           if let futureDate = self.dateFormatter.date(from: willExpire)
                           {
                            let newItemAdded = ItemsAdded(itemName: itemName, warrentyExpire: willExpire, timeLeft: self.daysBetween(start: self.currentDate, end: futureDate), progressStatus: Float((self.daysBetween(start: self.currentDate, end: futureDate))) / Float(daysLeft))
                           
                            
                            self.itemsAdded.append(newItemAdded)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            }
                        }
                    }
                   }
                }
            }
         
    
        }
    }
    func daysBetween(start: Date, end: Date) -> Int {
            return Calendar.current.dateComponents([.day], from: start, to: end).day!
        
        }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       performSegue(withIdentifier: "additemSegue", sender: self)
         
        
    }
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "additemSegue"
        {
            let destinationVC = segue.destination as! EditViewController
                destinationVC.selectedCategory = selectedCategory
           
        }
        if segue.identifier == "gotoItemSegue"
        {
            let destinationVC = segue.destination as! ItemDetailsViewController
            destinationVC.selectedItem = selectedItem
              destinationVC.selectedCategory = selectedCategory
            destinationVC.totalDaysLeft = totalDaysLeft
            destinationVC.progressBarStatus = progressBarStatus
            }
                  
        }
       
    
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemsAdded.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemViewCell
        
        cell.itemNameLabel.text = itemsAdded[indexPath.row].itemName
        cell.warrentyDateLabel.text = itemsAdded[indexPath.row].warrentyExpire
        cell.warrentyTimeLabel.text = (String(itemsAdded[indexPath.row].timeLeft) + " " + "days")
        cell.progressBar.progress = itemsAdded[indexPath.row].progressStatus
        if cell.progressBar.progress <= 0.35
        {
            cell.progressBar.progressTintColor = UIColor.systemRed
        }
        
        return  cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
         selectedItem = itemsAdded[indexPath.row].itemName
        totalDaysLeft = itemsAdded[indexPath.row].timeLeft
        progressBarStatus = itemsAdded[indexPath.row].progressStatus
        
        performSegue(withIdentifier: "gotoItemSegue", sender: self)
    }
    
    
   

}
