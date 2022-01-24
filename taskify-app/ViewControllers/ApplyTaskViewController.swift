//
//  ApplyTaskViewController.swift
//  taskify-app
//
//  Created by Ali Ahad
//

import UIKit
import CoreData

class ApplyTaskViewController: UIViewController {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var taskPostedBy: UILabel!
    @IBOutlet weak var taskNumOfHours: UILabel!
    @IBOutlet weak var taskHourRate: UILabel!
    @IBOutlet weak var taskStartDate: UILabel!
    @IBOutlet weak var taskLocation: UILabel!
    
    @IBOutlet weak var proposalDescription: UITextField!
    
    var task: Task? = nil
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        taskTitle.text = task?.title
        taskDescription.text = task?.detail
        taskNumOfHours.text = String(Int16(task!.hours))
        taskHourRate.text = String(Int16(task!.ratePerHour))
        taskPostedBy.text = task?.requester?.name
        taskStartDate.text = formatDate(date: (task?.startDate)!)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // Event handler for submitting proposal for a task
    @IBAction func submitProposal(_ sender: UIButton) {
        
        let taskProposal = TaskProposal(context: context)
        taskProposal.details = proposalDescription.text
        taskProposal.status = "PENDING"
        taskProposal.submissionDate = Date()
        
        taskProposal.task = task
        taskProposal.tasker = fetchUser()
        
        do {
            try context.save()
            self.view.showToast(toastMessage: "Applied successfully", duration: 2.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.navigationController?.popViewController(animated: true)
            }
        } catch {
            print("Error while saving proposal")
        }
        
        task?.status = "PENDING"
        
        do {
            try context.save()
        } catch {
            print("Error while updating task")
        }
    }
    
    // Fetching logged in user data from core data
    private func fetchUser() -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "email == %@", Configs.loggedInUserEmail)
        
        do {
            let user = try context.fetch(request)
            return user[0]
        } catch {
            print("Error while getting user")
            return nil
        }
    }
    
    // Format date to string
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        return formatter.string(from: date)
    }

}
