//
//  ProposalViewController.swift
//  taskify-app
//
//  Created by Sohail Shiraj
//

import UIKit
import CoreData

//view controller Class for accepting/rejecting proposals

class ProposalViewController: UIViewController {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var taskNumOfHours: UILabel!
    @IBOutlet weak var taskHourRate: UILabel!
    @IBOutlet weak var taskLocation: UILabel!
    @IBOutlet weak var taskStartDate: UILabel!
    @IBOutlet weak var taskProposalFrom: UILabel!
    @IBOutlet weak var proposalDetails: UILabel!
    
    var taskProposal: TaskProposal?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let task = taskProposal?.task
        
        taskTitle.text = task?.title
        taskDescription.text = task?.detail
        taskNumOfHours.text = String(Int16(task!.hours))
        taskHourRate.text = String(Int16(task!.ratePerHour))
        taskLocation.text = "Waterloo"//task?.location?.name
        taskProposalFrom.text = taskProposal?.tasker?.name
        proposalDetails.text = taskProposal?.details
        taskStartDate.text = formatDate(date: (task?.startDate)!)
    }
    
    //Hiding navigation bar on this screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //Show navigation bar once out of screen
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //Event handler for accepting proposal
    @IBAction func acceptProposal(_ sender: UIButton) {
        taskProposal?.status = "ACCEPTED"
        taskProposal?.task?.status = "IN_PROGRESS"
        taskProposal?.task?.tasker = taskProposal?.tasker
        
        do {
            try context.save()
            self.view.showToast(toastMessage: "Proposal accepted", duration: 2.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.navigationController?.popViewController(animated: true)
            }
        } catch {
            print("Error while updating task")
        }
    }
    
    //Event handler for declining proposal from tasker
    @IBAction func declineProposal(_ sender: UIButton) {
        taskProposal?.status = "DECLINED"
        taskProposal?.task?.status = "CREATED"
        
        do {
            try context.save()
            self.view.showToast(toastMessage: "Proposal accepted", duration: 2.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.navigationController?.popViewController(animated: true)
            }
        } catch {
            print("Error while updating task")
        }
    }
    
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        return formatter.string(from: date)
    }

}
