//
//  TaskerTaskViewCell.swift
//  taskify-app
//
//  Created by Ali Ahad
//

import UIKit

class TaskerTaskViewCell: UITableViewCell {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var taskPostedBy: UILabel!
    @IBOutlet weak var taskLocation: UILabel!
    @IBOutlet weak var taskNumOfHours: UILabel!
    @IBOutlet weak var taskHourRate: UILabel!
    @IBOutlet weak var taskDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
