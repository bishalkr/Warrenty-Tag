//
//  LoginViewController.swift
//  Warrenty Tag
//
//  Created by Bishal kumar  on 24/07/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        passwordTextField.delegate  = self
        emailTextField.delegate = self
        
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text , let password = passwordTextField.text
        {
            Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                if let e = error
                {
                    if let errorCode = AuthErrorCode(rawValue: e._code)
                    {
                        switch errorCode {
                        case .userNotFound:
                            let alert = UIAlertController(title: "Oops", message: "User Not found", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
                            
                           
                            self.present(alert, animated: true, completion: nil)
                            break
                            
                        case .wrongPassword:
                        
                            let alert = UIAlertController(title: "Oops", message: "Wrong password entered", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
                          
                          
                            self.present(alert, animated: true, completion: nil)
                        
                        case .invalidEmail:
                        
                            let alert = UIAlertController(title: "Oops", message: "Please enter a valid email address", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
                          
                          
                            self.present(alert, animated: true, completion: nil)
                            break
                
                        default:
                            print(e.localizedDescription)
                        }
                    }
                }
                else{
                    self.performSegue(withIdentifier: "logintoCategory", sender: self)
                }
             }
            
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

