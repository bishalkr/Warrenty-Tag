//
//  ViewController.swift
//  Warrenty Tag
//
//  Created by Bishal kumar  on 21/07/21.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        loadMainScreen()
        super.viewDidLoad()
      
       }
    
    func loadMainScreen()
    {
        if Auth.auth().currentUser != nil
        
        {  DispatchQueue.main.async {
            self.performSegue(withIdentifier: "loadingMainScreen", sender: self)
        }
            
        }
    }
    

}

