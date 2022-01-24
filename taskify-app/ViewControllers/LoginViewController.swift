//
//  LoginViewController.swift
//  taskify-app
//
//  Created by Jignesh Kumavat
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var userType: UISegmentedControl!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var userEmailErrorLabel: UILabel!
    @IBOutlet weak var userPasswordErrorLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        initialize();
    }
    
    //Initialize form
    func initialize() {
        resetForm();
    }
    
    //event handler for login button
    @IBAction func loginUser(_ sender: Any) {
        if(validate()){
            let email = userEmail.text
            let password = userPassword.text
            
            let request: NSFetchRequest<User> = User.fetchRequest()
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "email == %@ AND password = %@", email!, password!)
            
            do {
                let user = try context.fetch(request)
                if(user.first != nil){
                    Configs.loggedInUserEmail = (user.first?.email)!
                    
                    if (userType.selectedSegmentIndex == 0) {
                        self.performSegue(withIdentifier: "taskerDashboardSegue", sender: self)
                    } else {
                        self.performSegue(withIdentifier: "requesterDashboardSegue", sender: self)
                    }
                } else {
                    self.view.showToast(toastMessage: "Login Credentials are not correct", duration: 2)
                    print("Login Credentials not correct")
                }
            } catch {
                print ("Error getting user")
            }
            
        }
    }
    
    //reset form fields
    private func resetForm() {
        userEmail.text = ""
        userPassword.text = ""
        
        resetErrors()
    }
    
    //reset errors
    private func resetErrors() {
        userEmailErrorLabel.text = ""
        userEmailErrorLabel.isHidden = true
        
        userPasswordErrorLabel.text = ""
        userPasswordErrorLabel.isHidden = true
    }
    
    //validate fields
    private func validate() -> Bool {
        resetErrors()
        
        var isValid = true;
        
        if (userEmail.text == "") {
            userEmailErrorLabel.text = "*User email is required"
            userEmailErrorLabel.isHidden = false
            isValid = false
        }
        
        if (userEmail.text != "" && !validateEmail()) {
            userEmailErrorLabel.text = "*Invalid email"
            userEmailErrorLabel.isHidden = false
            userEmail.text = ""
            isValid = false
        }
        
        if (userPassword.text == "") {
            userPasswordErrorLabel.text = "*User password is required"
            userPasswordErrorLabel.isHidden = false
            isValid = false
        }
        
        return isValid
    }
    
    //validator for email
    private func validateEmail() -> Bool {
        let emailPattern = #"^\S+@\S+\.\S+$"#
        
        let result = userEmail.text!.range(
            of: emailPattern,
            options: .regularExpression
        )
        
        return (result != nil)
    }
        
    //dismissing keyboard
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
