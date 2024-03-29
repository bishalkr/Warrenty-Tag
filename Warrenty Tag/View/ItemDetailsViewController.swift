//
//  ItemDetailsViewController.swift
//  Warrenty Tag
//
//  Created by Bishal kumar  on 31/08/21.
//

import UIKit
import Firebase

class ItemDetailsViewController: UIViewController {
    
    @IBOutlet weak var warrentyPeriod: UILabel!
    @IBOutlet weak var notifyBefore: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var willExpireLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var purchasedDataLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    let billImageView = UIImageView(frame: CGRect(x: 20, y: 50, width: 250, height: 230))
    let db = Firestore.firestore()
    var selectedCategory : Category?
    var selectedItem: String?
    var totalDaysLeft: Int?
    var progressBarStatus: Float?
    var itemsAdded: ItemsAdded?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downlaodItemImage()
        loadDetails()
    }
    
    
    
    @objc func onTap()
    {
        dismiss(animated: true, completion: nil)
     
       if let items = billImageView.image
       {
        let ac = UIActivityViewController(activityItems: [items], applicationActivities: nil)
        
        present(ac, animated: true, completion: nil)
       }
    
    }
    
    //MARK: - DOWNLOADING ITEM IMAGE FROM FIREBASE
    
    func downlaodItemImage()
    {
        let user = Auth.auth().currentUser
        if let user = user
        {
           let userID = user.uid
    
        let itemUploadRef = Storage.storage().reference(withPath: "users/itemImage/\(userID)/\(selectedItem!).jpg")
       
            
         itemUploadRef.getData(maxSize: 6 * 1024 * 1024) { data, error in
                if let e = error
                
                {
                    print("Error while downloading Item Image - \(e.localizedDescription)")
                    return
                }
                if let data = data
                {
                    DispatchQueue.main.async {
                        self.itemImage.image = UIImage(data: data)
                    }
                   
                }
                
            }
        }
    }
    
    //MARK: - DOWLOADING BILL FROM FIREBASE
    
    @IBAction func downloadBill(_ sender: UIButton) {
        
        let user = Auth.auth().currentUser
        if let user = user
        {
           let userID = user.uid
    
        
        let billUploadRef = Storage.storage().reference(withPath: "users/billImage/\(userID)/\(selectedItem!).jpg")
            
         billUploadRef.getData(maxSize: 6 * 1024 * 1024) { data, error in
                if let e = error
                
                {
                    let errorAlert = UIAlertController(title: "Bill not found", message: "You have not uploaded Bill for this Item", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                    print("Error while downloading Item Image - \(e.localizedDescription)")
                    return
                }
                if let data = data
                {
                    
                    let alert = UIAlertController(title: "Your BILL", message: nil, preferredStyle: .alert)
                  
                   
                    self.billImageView.image = UIImage(data: data)
                    let action = UIAlertAction(title: "Close", style: .cancel, handler: nil)
                    alert.view.addSubview(self.billImageView)
                    
                 let height = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320)
                 let width = NSLayoutConstraint(item: alert.view!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
                    
               alert.view.addConstraint(height)
               alert.view.addConstraint(width)
               alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                    self.billImageView.isUserInteractionEnabled = true
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTap))
                    self.billImageView.addGestureRecognizer(tap)
                
                }
                
            }
        }
    }
    
    //MARK: - FECTHING FROM FIREBASE AND DISPLAYING
    
    func loadDetails()
    {
        let user = Auth.auth().currentUser
        if let user = user
        {
            let userID = user.uid
        
            
            db.collection("users/\(userID)/\(selectedCategory!.categoryTitle!)").whereField("Name", isEqualTo: selectedItem!).getDocuments { querySnapShot, error in
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
                                if let itemName = data["Name"] as? String, let itemAdress = data["Address"] as? String, let itemPurchasedDate = data["PurchasedDate"] as? String, let itemWarrenty = data["WarrentyPeriod"] as? Int, let itemNotes = data["Notes"] as? String, let notifyBefore = data["Notified"] as? String, let willExpire = data["Will Expire on"] as? String
                                {
        
                                    DispatchQueue.main.async {
                                        self.nameLabel.text = itemName
                                        self.addressLabel.text = itemAdress
                                        self.daysLeftLabel.text = String(describing: self.totalDaysLeft!) +  " " + "days"
                                        self.purchasedDataLabel.text = itemPurchasedDate
                                        self.notifyBefore.text = notifyBefore
                                        self.notesLabel.text = itemNotes
                                        self.willExpireLabel.text = willExpire
                                        self.warrentyPeriod.text = String(itemWarrenty) + "" + "months"
                                        self.progressBar.progress = self.progressBarStatus!
                                        if self.progressBar.progress <= 0.30
                                        {
                                            self.progressBar.progressTintColor = UIColor.systemRed
                                        }
        
        
                                    }
                                }
                            }
                           }
                        }
            }

            }
        }
    
   
    
    
   
    
    
    }
                
    
    
    
    
    



    
