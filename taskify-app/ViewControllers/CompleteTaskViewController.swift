//
//  CompleteTaskViewController.swift
//  taskify-app
//
//  Created by Ali Ahad
//

import UIKit

class CompleteTaskViewController: UIViewController {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var taskNumOfHours: UILabel!
    @IBOutlet weak var taskHourRate: UILabel!
    @IBOutlet weak var taskLocation: UILabel!
    @IBOutlet weak var taskStartDate: UILabel!
    @IBOutlet weak var tasker: UILabel!
    @IBOutlet weak var ratingControl: UISegmentedControl!
    @IBOutlet weak var feedback: UITextField!
    
    var task: Task? = nil
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        taskTitle.text = task?.title
        taskDescription.text = task?.detail
        taskNumOfHours.text = String(Int16(task!.hours))
        taskHourRate.text = String(Int16(task!.ratePerHour))
        taskLocation.text = "Waterloo"//task?.location?.name
        taskStartDate.text = formatDate(date: (task?.startDate)!)
        tasker.text = task?.requester?.name
        
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
    
    // Event handler for completing task
    @IBAction func completeTask(_ sender: UIButton) {
        
        let rating = ratingControl.selectedSegmentIndex + 1
        
        let taskFeedback = TaskFeedback(context: context)
        taskFeedback.rating = Int16(rating)
        taskFeedback.review = feedback.text
        taskFeedback.date = Date()
        taskFeedback.task = task
        
        do {
            try context.save()
        } catch {
            print("Error while saving task feedback")
        }
        
        task?.status = "COMPLETED"
        
        do {
            try context.save()
            self.view.showToast(toastMessage: "Marked as completed", duration: 2.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.navigationController?.popViewController(animated: true)
            }
        } catch {
            print("Error while updating task")
        }
    }
    
    // Format date to string
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        return formatter.string(from: date)
    }
}
