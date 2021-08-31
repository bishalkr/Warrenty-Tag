//
//  EditViewController.swift
//  Warrenty Tag
//
//  Created by Bishal kumar  on 26/08/21.
//

import UIKit
import Firebase

class EditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var selectedCategory : Category?
    let billImageView = UIImageView()
    var notify: String?
    let db = Firestore.firestore()
    var toCheckWhoCalled: Int = 0
    let storage = Storage.storage().reference()
    var dismiss : Int = 0
 
    
   

    @IBOutlet weak var itemImageView: UIImageView!
    var datepicker = UIDatePicker()
    let imagePicker = UIImagePickerController()
    var newItem = Items()
    
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
        super.viewDidLoad()
        createDatePicker()
        
    }
    
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
        
        dateTextField.text = formatter.string(from: datepicker.date)
        self.view.endEditing(true)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateTextField
        {
         
            
        }
    }
    
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let userImage = info[.originalImage] as? UIImage
        {
            if toCheckWhoCalled == 1
            {
            newItem.itemImage = userImage
            itemImageView.image = userImage
            }
            if toCheckWhoCalled == 2
            {
                
                billImageView.image = userImage
            }
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func notifiedButton(_ sender: UIButton) {
        notify = sender.currentTitle
       
    }
    
    
    
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
    
    
    
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        imageUploadProgressBar.isHidden = false
        billUploadProgressBar.isHidden = false
        let userID: String
        let user = Auth.auth().currentUser
        if let user = user
        {
            userID = user.uid
    
        let itemUploadRef = Storage.storage().reference(withPath: "users/itemImage/\(userID).jpg")
        let billUploadRef = Storage.storage().reference(withPath: "users/billImage/\(userID).jpg")
        guard let imageData = itemImageView.image?.jpegData(compressionQuality: 0.75) else {return }
        guard let billImageData = billImageView.image?.jpegData(compressionQuality: 0.75) else {return}
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
       let taskReference1 =  itemUploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            if let e = error
            {
                print("Got an error \(e.localizedDescription)")
            }
            else
            {
                print("Upload Item completed")
                self.dismiss = self.dismiss + 1
                print(self.dismiss)
                if self.dismiss == 3
                {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        
       }
        taskReference1.observe(.progress) { [weak self] (snapshot) in
            guard let pctThere = snapshot.progress?.fractionCompleted else {return}
            DispatchQueue.main.async {
                self?.imageUploadProgressBar.progress = Float(pctThere)
            }
            
        }
        
           let taskReference2 =  billUploadRef.putData(billImageData, metadata: uploadMetadata) { (downloadMetadata2, error) in
                if let e = error
                {
                    print("Got an error \(e.localizedDescription)")
                }
                else
                {
                    print("Upload Bill completed")
                    self.dismiss = self.dismiss + 1
                    print(self.dismiss)
                }
            }
        
        taskReference2.observe(.progress) { [weak self] (snapshot) in
            guard let pctThere = snapshot.progress?.fractionCompleted else {return}
            DispatchQueue.main.async {
                self?.billUploadProgressBar.progress = Float(pctThere)
            }
          
        }
           
         
        newItem.itemName = nameTextField.text ?? ""
        newItem.itemAdress = addressTextField.text ?? ""
        newItem.notes = notesTextField.text
        newItem.notified = notify
        newItem.purchasedDate = dateTextField.text
        let text = warrentyTextField.text
        newItem.warrentyPeriod = Int(text ?? "0")
            selectedCategory?.itemArray?.append(newItem)
         
            db.collection("\(userID)/\(selectedCategory!.categoryTitle!)/\(newItem.itemName)").addDocument(data:
            
                                                                                                        
             ["Name": newItem.itemName,
             "Address" : newItem.itemAdress,
             "PurchasedDate" : newItem.purchasedDate!,
             "WarrentyPeriod" : newItem.warrentyPeriod!,
             "Notified" : newItem.notified! ,
             "Notes" : newItem.notes!
             ]) { error in
            if let e = error
            { print("Hello my name is BISHAL FIND me")
                print("Error while upload your data - \(e.localizedDescription)")
            }
            else
            {
                print("Uploaded your data ")
                self.dismiss = self.dismiss + 1
            }
        }
            
            
        }
        
      
}
    
}

