//
//  ItemViewController.swift
//  Warrenty Tag
//
//  Created by Bishal kumar  on 26/08/21.
//


import UIKit

class ItemViewController: UIViewController, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    var selectedCategory : Category?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        
        
        tableView.register(UINib(nibName: "ItemViewCell", bundle: nil), forCellReuseIdentifier: "itemCell")
        
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       performSegue(withIdentifier: "additemSegue", sender: self)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditViewController
       
            destinationVC.selectedCategory = selectedCategory

    
    }
    
   
}
