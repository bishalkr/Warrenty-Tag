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
     
        
        let itemUploadRef = Storage.storage().reference(withPath: "users/itemImage.jpg")
        let billUploadRef = Storage.storage().reference(withPath: "users/billImage.jpg")
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
                print("Upload completed")
            }
        
       }
        taskReference1.observe(.progress) { [weak self] (snapshot) in
            guard let pctThere = snapshot.progress?.fractionCompleted else {return}
            self?.imageUploadProgressBar.progress = Float(pctThere)
        }
        
           let taskReference2 =  billUploadRef.putData(billImageData, metadata: uploadMetadata) { (downloadMetadata2, error) in
                if let e = error
                {
                    print("Got an error \(e.localizedDescription)")
                }
                else
                {
                    print("Upload completed")
                }
            }
        
        taskReference2.observe(.progress) { [weak self] (snapshot) in
            guard let pctThere = snapshot.progress?.fractionCompleted else {return}
            self?.billUploadProgressBar.progress = Float(pctThere)
        }
        
            
        
        
        
     
        newItem.itemName = nameTextField.text ?? ""
        
        newItem.itemAdress = addressTextField.text ?? ""
        newItem.notes = notesTextField.text
        newItem.notified = notify
        let text = warrentyTextField.text
        newItem.warrentyPeriod = Int(text ?? "0")
        
        
    
    
    
    
}
}
