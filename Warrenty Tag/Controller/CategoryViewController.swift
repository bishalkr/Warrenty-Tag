//
//  CategoryViewController.swift
//  Warrenty Tag
//
//  Created by Bishal kumar  on 24/07/21.
//

import UIKit
import Firebase

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var editBarButton: UIButton!
    var categoryArray : [Category]?
    
    let mobileCell = Category(categoryTitle: "Mobile and Accesories", categorySymbol: UIImage(systemName: "phone.fill")!, dateOfCategoryCreation: Date(), isEditable : false)
    
    let laptopCell = Category(categoryTitle: "Laptop and Accesories", categorySymbol: UIImage(systemName: "laptopcomputer")!, dateOfCategoryCreation: Date(), isEditable : false)
    
    let bandCell = Category(categoryTitle: "Smartwatch and Band ", categorySymbol: UIImage(systemName: "applewatch.watchface")!, dateOfCategoryCreation: Date(), isEditable : false)
    let earphoneCell = Category(categoryTitle: "Earphones and Headphpones", categorySymbol: UIImage(systemName: "airpodspro")!, dateOfCategoryCreation: Date(), isEditable : false)
    let cameraCell = Category(categoryTitle: "Camera", categorySymbol: UIImage(systemName: "camera.fill")!, dateOfCategoryCreation: Date(), isEditable : false)
    let homeCell = Category(categoryTitle: "Home and Kitchen Appliances", categorySymbol: UIImage(systemName: "house.fill")!, dateOfCategoryCreation: Date(), isEditable : false)
    let electroniCell = Category(categoryTitle: "Other electronics Applicances", categorySymbol: UIImage(systemName: "network")!, dateOfCategoryCreation: Date(), isEditable : false)
    let bagCell = Category(categoryTitle: "Bags and Luggages", categorySymbol: UIImage(systemName: "bag.fill")!, dateOfCategoryCreation: Date(), isEditable : false)
    let medicinesCell = Category(categoryTitle: "Meds", categorySymbol: UIImage(systemName: "cross.case.fill")!, dateOfCategoryCreation: Date(), isEditable : false)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryArray = [mobileCell,laptopCell,bandCell,earphoneCell,cameraCell,homeCell,electroniCell,bagCell,medicinesCell]
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.hidesBackButton = true
        
        let user = Auth.auth().currentUser
        if let user = user {
          let email = user.email
            self.title = email
    
        }
        tableView.reloadData()
        
    }
    
    
    //MARK: - ADD BUTTON
    @IBAction func addButtonClicked(_ sender: Any) {
        
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(categoryTitle: textfield.text ?? "", categorySymbol: UIImage(systemName: "heart.fill")! , dateOfCategoryCreation: Date(), isEditable : true)
            
            self.categoryArray?.append(newCategory)
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type the category here"
            textfield = alertTextField
            
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    
        
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]

    }
    }
    
    
//MARK: - Log out Button
    
    @IBAction func LogoutButtonClicked(_ sender: Any){
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
       
    }
    
    //MARK: - Edit Buttom
    
    @IBAction func editButtonClicked(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        
        if tableView.isEditing
        {
            editBarButton.setTitle("Done", for: .normal)
        }
        else
        {
            editBarButton.setTitle("Edit", for: .normal)
        }
        
        }
    
    
    }

//MARK: - TableView DataSource and Delegate Methods


extension CategoryViewController : UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryPrototype", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].categoryTitle ?? "Nothing Added"
        cell.imageView?.image = categoryArray?[indexPath.row].categorySymbol
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        performSegue(withIdentifier: "itemSegue", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemSelected = categoryArray![sourceIndexPath.row]
        categoryArray!.remove(at: sourceIndexPath.row)
        categoryArray!.insert(itemSelected, at: destinationIndexPath.row)
    }
  

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if categoryArray![indexPath.row].isEditable == false
        {
        return UITableViewCell.EditingStyle.none
        }
        else
        {
            return UITableViewCell.EditingStyle.delete
        }
    }
    
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
            tableView.beginUpdates()
            categoryArray?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
           
            tableView.endUpdates()
        
            
        }
    
}
