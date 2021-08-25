//
//  RegisterViewController.swift
//  Warrenty Tag
//
//  Created by Bishal kumar  on 24/07/21.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextFeild: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var createPasswordTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        mailTextField.delegate = self
        confirmPasswordTextFeild.delegate = self
        createPasswordTextField.delegate = self
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        mailTextField.resignFirstResponder()
        confirmPasswordTextFeild.resignFirstResponder()
        createPasswordTextField.resignFirstResponder()
        if createPasswordTextField.text == confirmPasswordTextFeild.text
        {
        if let email = mailTextField.text , let password = createPasswordTextField.text
        {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e  = error {
                    if let errorCode = AuthErrorCode(rawValue: e._code)
                    {
                        
                        switch(errorCode)
                        {
                        case .invalidEmail :
                            self.mailTextField.layer.borderColor = UIColor.red.cgColor
                            self.mailTextField.layer.borderWidth = 1.0
                            self.emailLabel.text = "Invalid email"
                            break
                          
                        case .emailAlreadyInUse:
                            self.mailTextField.layer.borderColor = UIColor.red.cgColor
                            self.mailTextField.layer.borderWidth = 1.0
                            self.emailLabel.text = "Email already in Use"
                            break
                            
                        case .weakPassword :
                            self.createPasswordTextField.layer.borderColor = UIColor.red.cgColor
                            self.createPasswordTextField.layer.borderWidth = 1.0
                            self.confirmPasswordTextFeild.layer.borderColor = UIColor.red.cgColor
                            self.confirmPasswordTextFeild.layer.borderWidth = 1.0
                            self.passwordLabel.text = "Use a password of lenght 6 or more"
                            break
                       
                        default :
                            print("others")
                        
                        }
             }
                }
                else
                {
                    
                    self.performSegue(withIdentifier: "registertoCategory", sender: self)
                }
                
            }
        }
        }
        else
        {
            self.createPasswordTextField.layer.borderColor = UIColor.red.cgColor
            self.createPasswordTextField.layer.borderWidth = 1.0
            self.confirmPasswordTextFeild.layer.borderColor = UIColor.red.cgColor
            self.confirmPasswordTextFeild.layer.borderWidth = 1.0
            self.passwordLabel.text = "Confirm password didn't match"
        }
            
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField ==  mailTextField
        {
            mailTextField.layer.borderColor = UIColor.clear.cgColor
            emailLabel.text = ""
            
        }
         if textField == createPasswordTextField || textField == confirmPasswordTextFeild
         {
            createPasswordTextField.layer.borderColor = UIColor.clear.cgColor
            confirmPasswordTextFeild.layer.borderColor = UIColor.clear.cgColor
            passwordLabel.text = " "
         }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        view.endEditing(true)
    }
    

}

