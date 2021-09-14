//
//  EditViewController.swift
//  Warrenty Tag
//
//  Created by Bishal kumar  on 26/08/21.
//

import UIKit
import Firebase
import UserNotifications


class EditViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
   
    
    var selectedCategory : Category?
    let billImageView = UIImageView()
    var notify: String = "3 days"
    let db = Firestore.firestore()
    var toCheckWhoCalled: Int = 0
    let storage = Storage.storage().reference()
//    var dismiss : Int = 0
    @IBOutlet weak var itemImageView: UIImageView!
    var datepicker = UIDatePicker()
    let imagePicker = UIImagePickerController()
    var newItem = Items()
    var enteredDate = Date()
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    @IBOutlet weak var thirtyDaysButton: UIButton!
    @IBOutlet weak var threedaysButton: UIButton!
    @IBOutlet weak var sevenDaysButton: UIButton!
    @IBOutlet weak var billUploadProgressBar: UIProgressView!
    @IBOutlet weak var imageUploadProgressBar: UIProgressView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var warrentyTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        
        imagePicker.delegate = self
        billUploadProgressBar.isHidden = true
        imageUploadProgressBar.isHidden = true
        threedaysButton.isSelected = true
        super.viewDidLoad()
        createDatePicker()
        
    }
  
    //MARK: - CREATING DATE PICKER
    func createDatePicker()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donedatePressed))
        toolbar.setItems([doneButton], animated: true)
        dateTextField.inputAccessoryView = toolbar
        datepicker.preferredDatePickerStyle = .wheels
        datepicker.datePickerMode = .date
        dateTextField.inputView = datepicker
    }
    
    
    @objc func donedatePressed()
  
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "dd/MM/yyyy"
        enteredDate = datepicker.date
        dateTextField.text = formatter.string(from: datepicker.date)
        self.view.endEditing(true)
    }
    
    func daysBetween(start: Date, end: Date) -> Int {
            return Calendar.current.dateComponents([.day], from: start, to: end).day!
        
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        view.endEditing(true)
    }
    

    @IBAction func notifiedButton(_ sender: UIButton) {
        

        notify = sender.currentTitle!
        
        if notify == "3 days"
        {
            threedaysButton.isSelected = true
            sevenDaysButton.isSelected = false
            thirtyDaysButton.isSelected = false
            
        }
        else if notify == "7 days"
        {
            threedaysButton.isSelected = false
            sevenDaysButton.isSelected = true
            thirtyDaysButton.isSelected = false
        }
        else if notify == "30 days"
        {
            threedaysButton.isSelected = false
            sevenDaysButton.isSelected = false
            thirtyDaysButton.isSelected = true
        }

    }

    //MARK: - ADD BUTTON METHOD to add Item Image
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        
        let alert = UIAlertController(title: "Add Photo", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: { (cameraAction) in
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.toCheckWhoCalled = 1
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { (libraryAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.toCheckWhoCalled = 1
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
        
    }
    

     //MARK: - ADD BILL IMAGE
    
    
    @IBAction func uploadButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Add Bill", message:"Add bill from camera or photo library", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: { (cameraAction) in
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.toCheckWhoCalled = 2
            self.present(self.imagePicker, animated: true, completion: nil)
            
            }))
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { (libraryAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.toCheckWhoCalled = 2
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func didFailWithError(message: String)
    {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    

    @IBAction func doneButtonPressed(_ sender: UIButton) {
       
        
        if(uploadData())
        {
            self.dismiss(animated: true, completion: nil)
        }
       
        
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
//        formatter.dateFormat = "dd/MM/yyyy"
//
//
//
//        newItem.itemName = nameTextField.text ?? ""
//        newItem.itemAdress = addressTextField.text ?? ""
//        newItem.notes = notesTextField.text
//        newItem.notified = notify
//        newItem.purchasedDate = dateTextField.text
//
//        let text = warrentyTextField.text
//        newItem.warrentyPeriod = Int(text ?? "0")
//
//
//
//
//        var dateComponent = DateComponents()
//        dateComponent.month = newItem.warrentyPeriod
//        if let futureDate = Calendar.current.date(byAdding: dateComponent, to: enteredDate)
//        {
//        newItem.futureDate = formatter.string(from: futureDate)
//        newItem.daysLeft = daysBetween(start: enteredDate, end: futureDate)
//
//
//
//
//
//
//
//
//        content.title = "Warrenty Expire soon"
//        content.body = "Your \(newItem.itemName) warrenty is going to expire in \(notify!) "
//            content.sound = .default
//            var notifyDatecomponent = DateComponents()
//
//        if notify == "3 days" {
//            notifyDatecomponent.day = newItem.daysLeft! - 3
//        }
//            if notify == "7 days"
//            {
//                notifyDatecomponent.day = newItem.daysLeft! - 7
//            }
//
//            if notify == "30 days"
//            {
//                notifyDatecomponent.day = newItem.daysLeft! - 30
//            }
//
//
//            if let notifiedDate = Calendar.current.date(byAdding: notifyDatecomponent, to: enteredDate) {
//
//
//                newItem.notifyDate = formatter.string(from: notifiedDate)
//
//            let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: notifiedDate)
//
//
//
//            }
//        }
//
//
//
//
//
//
//
//
//
//            selectedCategory?.itemArray?.append(newItem)
//
//
//
//        let userID: String
//        let user = Auth.auth().currentUser
//        if let user = user
//        {
//            userID = user.uid
//
//
//
//            db.collection("users/\(userID)/\(selectedCategory!.categoryTitle!)").addDocument(data:
//
//
//             ["Name": newItem.itemName!,
//             "Address" : newItem.itemAdress!,
//             "PurchasedDate" : newItem.purchasedDate!,
//             "WarrentyPeriod" : newItem.warrentyPeriod!,
//             "Notified" : newItem.notified! ,
//             "Notes" : newItem.notes!,
//             "Will Expire on": newItem.futureDate!,
//             "Days Left": newItem.daysLeft!,
//             "Notify Date": newItem.notifyDate!
//             ]) { error in
//            if let e = error
//            {
//                print("Error while upload your data - \(e.localizedDescription)")
//            }
//            else
//            {
//                print("Uploaded your data ")
//                self.dismiss = self.dismiss + 1
//            }
//        }
//
//
//
//
//
//
//
//
//
//
//            let itemUploadRef = Storage.storage().reference(withPath: "users/itemImage/\(userID)/\(newItem.itemName!).jpg")
//            let billUploadRef = Storage.storage().reference(withPath: "users/billImage/\(userID)/\(newItem.itemName!).jpg")
//        guard let imageData = itemImageView.image?.jpegData(compressionQuality: 0.75) else {return }
//        guard let billImageData = billImageView.image?.jpegData(compressionQuality: 0.75) else {return}
//        let uploadMetadata = StorageMetadata.init()
//        uploadMetadata.contentType = "image/jpeg"
//       let taskReference1 =  itemUploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
//            if let e = error
//            {
//                print("Got an error \(e.localizedDescription)")
//            }
//            else
//            {
//                print("Upload Item completed")
//                self.dismiss = self.dismiss + 1
//                print(self.dismiss)
//                if self.dismiss == 3
//                {
//                    self.dismiss(animated: true, completion: nil)
//                }
//            }
//
//       }
//        taskReference1.observe(.progress) { [weak self] (snapshot) in
//            guard let pctThere = snapshot.progress?.fractionCompleted else {return}
//            DispatchQueue.main.async {
//                self?.imageUploadProgressBar.progress = Float(pctThere)
//            }
//
//        }
//
//           let taskReference2 =  billUploadRef.putData(billImageData, metadata: uploadMetadata) { (downloadMetadata2, error) in
//                if let e = error
//                {
//                    print("Got an error \(e.localizedDescription)")
//                }
//                else
//                {
//                    print("Upload Bill completed")
//                    self.dismiss = self.dismiss + 1
//                    print(self.dismiss)
//                    if self.dismiss == 3
//                    {
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                }
//            }
//
//        taskReference2.observe(.progress) { [weak self] (snapshot) in
//            guard let pctThere = snapshot.progress?.fractionCompleted else {return}
//            DispatchQueue.main.async {
//                self?.billUploadProgressBar.progress = Float(pctThere)
//            }
//
//        }
//
//
//
            
//        }
        
      
}
    //MARK: - UPLOADING DATA TO FIREBASE
    
    func uploadData() -> Bool
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "dd/MM/yyyy"
    
        if nameTextField.text!.isEmpty || addressTextField.text!.isEmpty || notesTextField.text!.isEmpty || dateTextField.text!.isEmpty || warrentyTextField.text!.isEmpty {
            
            didFailWithError(message: "All fields are mandatory to fill!")
            return false
        } else{
           
            newItem.itemName = nameTextField.text!
            newItem.itemAdress = addressTextField.text!
            newItem.notes = notesTextField.text!
        newItem.notified = notify
            newItem.purchasedDate = dateTextField.text
            newItem.warrentyPeriod = Int(warrentyTextField.text!)
        
        
        var dateComponent = DateComponents()
        dateComponent.month = newItem.warrentyPeriod
        if let futureDate = Calendar.current.date(byAdding: dateComponent, to: enteredDate)
        {
        newItem.futureDate = formatter.string(from: futureDate)
        newItem.daysLeft = daysBetween(start: enteredDate, end: futureDate)
       
        content.title = "Warrenty Expire soon"
        content.body = "Your \(newItem.itemName!) warrenty is going to expire in \(notify) "
            content.sound = .default
            var notifyDatecomponent = DateComponents()
       
        if notify == "3 days" {
            notifyDatecomponent.day = newItem.daysLeft! - 3
        }
            if notify == "7 days"
            {
                notifyDatecomponent.day = newItem.daysLeft! - 7
            }
            
            if notify == "30 days"
            {
                notifyDatecomponent.day = newItem.daysLeft! - 30
            }
            
           
            if let notifiedDate = Calendar.current.date(byAdding: notifyDatecomponent, to: enteredDate) {
                newItem.notifyDate = formatter.string(from: notifiedDate)
            }
        }
    
       
            selectedCategory?.itemArray?.append(newItem)
        
         
            
            
        let userID: String
        let user = Auth.auth().currentUser
        if let user = user
        
        {
            userID = user.uid
            db.collection("users/\(userID)/\(selectedCategory!.categoryTitle!)").addDocument(data:
             ["Name": newItem.itemName!,
             "Address" : newItem.itemAdress!,
             "PurchasedDate" : newItem.purchasedDate!,
             "WarrentyPeriod" : newItem.warrentyPeriod!,
             "Notified" : newItem.notified! ,
             "Notes" : newItem.notes!,
             "Will Expire on": newItem.futureDate!,
             "Days Left": newItem.daysLeft!,
             "Notify Date": newItem.notifyDate!
             ]) { error in
            if let e = error
            { self.didFailWithError(message: "Couldn't upload your data due to some error")
                print("Error while upload your data - \(e.localizedDescription)")
               
            }
            else
            {
                print("Uploaded your data ")
//                self.dismiss = self.dismiss + 1
            }
        }
    
        uploadImage(userID)
            
    
        }
            return true
        }
       
        
       
    }
    
    
    //MARK: - UPLOADING IMAGES TO FIREBASE
    
    func uploadImage(_ userID: String)
    {
        let itemUploadRef = Storage.storage().reference(withPath: "users/itemImage/\(userID)/\(newItem.itemName!).jpg")
        let billUploadRef = Storage.storage().reference(withPath: "users/billImage/\(userID)/\(newItem.itemName!).jpg")
    guard let imageData = itemImageView.image?.jpegData(compressionQuality: 0.75) else {return  }
    guard let billImageData = billImageView.image?.jpegData(compressionQuality: 0.75) else {return }
    let uploadMetadata = StorageMetadata.init()
    uploadMetadata.contentType = "image/jpeg"
   let taskReference1 =  itemUploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
        if let e = error
        {
            self.didFailWithError(message: "Couldn't Upload Image due to an error")
            print("Got an error \(e.localizedDescription)")
        }
        else
        {
            print("Upload Item completed")
            
        }
    
   }
    taskReference1.observe(.progress) { [weak self] (snapshot) in
        
        guard let pctThere = snapshot.progress?.fractionCompleted else {return}
        DispatchQueue.main.async {
            self!.imageUploadProgressBar.isHidden = false
            self?.imageUploadProgressBar.progress = Float(pctThere)
        }
        
    }
    
       let taskReference2 =  billUploadRef.putData(billImageData, metadata: uploadMetadata) { (downloadMetadata2, error) in
            if let e = error
            
            {
                self.didFailWithError(message: "Error while uploading bill")
                print("Got an error \(e.localizedDescription)")
                return
            }
            else
            {
                print("Upload Bill completed")
            
            }
        }
    
    taskReference2.observe(.progress) { [weak self] (snapshot) in
        guard let pctThere = snapshot.progress?.fractionCompleted else {return}
        DispatchQueue.main.async {
            self!.billUploadProgressBar.isHidden = false
            self?.billUploadProgressBar.progress = Float(pctThere)
        }
      
    }
       
    }
    
}
//MARK: - IMAGE PICKER CONTROLLER METHODS

extension EditViewController : UIImagePickerControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let userImage = info[.originalImage] as? UIImage
        {
            if toCheckWhoCalled == 1
            {
//            newItem.itemImage = userImage
            itemImageView.image = userImage
            }
            if toCheckWhoCalled == 2
            {
                
                billImageView.image = userImage
            }
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

