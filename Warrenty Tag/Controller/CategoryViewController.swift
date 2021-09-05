//
//  CategoryViewController.swift
//  Warrenty Tag
//
//  Created by Bishal kumar  on 24/07/21.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var categoryArray : [Category]?
    let mobileCell = Category(categoryTitle: "Mobile and Accesories", categorySymbol: UIImage(systemName: "phone.fill")!, dateOfCategoryCreation: Date())
    
    let laptopCell = Category(categoryTitle: "Laptop and Accesories", categorySymbol: UIImage(systemName: "laptopcomputer")!, dateOfCategoryCreation: Date())
    let bandCell = Category(categoryTitle: "Smartwatch and Band ", categorySymbol: UIImage(systemName: "applewatch.watchface")!, dateOfCategoryCreation: Date())
    
    let earphoneCell = Category(categoryTitle: "Earphones and Headphpones", categorySymbol: UIImage(systemName: "airpodspro")!, dateOfCategoryCreation: Date())
    let cameraCell = Category(categoryTitle: "Camera", categorySymbol: UIImage(systemName: "camera.fill")!, dateOfCategoryCreation: Date())
    let homeCell = Category(categoryTitle: "Home and Kitchen Appliances", categorySymbol: UIImage(systemName: "house.fill")!, dateOfCategoryCreation: Date())
    let electroniCell = Category(categoryTitle: "Other electronics Applicances", categorySymbol: UIImage(systemName: "network")!, dateOfCategoryCreation: Date())
    let bagCell = Category(categoryTitle: "Bags and Luggages", categorySymbol: UIImage(systemName: "bag.fill")!, dateOfCategoryCreation: Date())
    let medicinesCell = Category(categoryTitle: "Meds", categorySymbol: UIImage(systemName: "cross.case.fill")!, dateOfCategoryCreation: Date())
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryPrototype", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].categoryTitle ?? "Nothing Added"
       cell.imageView?.image = categoryArray?[indexPath.row].categorySymbol
       
        
        return cell
        
    }
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryArray = [mobileCell,laptopCell,bandCell,earphoneCell,cameraCell,homeCell,electroniCell,bagCell,medicinesCell]
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.hidesBackButton = true
        tableView.reloadData()
        

        // Do any additional setup after loading the view.
    }
    
    
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(categoryTitle: textfield.text ?? "", categorySymbol: UIImage(systemName: "heart.fill")! , dateOfCategoryCreation: Date())
            self.categoryArray?.append(newCategory)
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type the category here"
            textfield = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "itemSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]

    }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
