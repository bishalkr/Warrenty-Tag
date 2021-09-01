//
//  ItemViewController.swift
//  Warrenty Tag
//
//  Created by Bishal kumar  on 26/08/21.
//


import UIKit
import Firebase

class ItemViewController: UIViewController, UITableViewDataSource{
   
    let db = Firestore.firestore()
    var selectedCategory : Category?
    @IBOutlet weak var tableView: UITableView!
    var itemsAdded: [ItemsAdded] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadtableView()
        
        tableView.register(UINib(nibName: "ItemViewCell", bundle: nil), forCellReuseIdentifier:"itemCell")
        
        
    }
    
    
    func loadtableView()
    {
        let user = Auth.auth().currentUser
        if let user = user
        {
            let userID = user.uid
            db.collection("users/\(userID)/\(selectedCategory!.categoryTitle!)").getDocuments { querySnapShot, error in
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
                        if let itemName = data["Name"] as? String
                        {
                            let newItemAdded = ItemsAdded(itemName: itemName, warrentyExpire: "12/12/2022", timeLeft: "20 months")
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
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       performSegue(withIdentifier: "additemSegue", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditViewController
       
            destinationVC.selectedCategory = selectedCategory

    
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemsAdded.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemViewCell
        
        cell.itemNameLabel.text = itemsAdded[indexPath.row].itemName
        cell.warrentyDateLabel.text = itemsAdded[indexPath.row].warrentyExpire
        cell.warrentyTimeLabel.text = itemsAdded[indexPath.row].timeLeft
        
        return  cell
        
    }
    
   
}
