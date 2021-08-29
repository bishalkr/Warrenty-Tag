//
//  ItemViewController.swift
//  Warrenty Tag
//
//  Created by Bishal kumar  on 26/08/21.
//


import UIKit

class ItemViewController: UIViewController {
    var selectedCategory : Category?
     override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       performSegue(withIdentifier: "additemSegue", sender: self)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditViewController
       
            destinationVC.selectedCategory = selectedCategory

    
    }
    
   
}
