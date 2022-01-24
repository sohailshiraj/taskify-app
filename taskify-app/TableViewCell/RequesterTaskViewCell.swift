//
//  RequesterTaskViewCell.swift
//  taskify-app
//
//  Created by Sohail Shiraj
//

import UIKit

class RequesterTaskViewCell: UITableViewCell {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var taskDate: UILabel!
    @IBOutlet weak var taskHourRate: UILabel!
    @IBOutlet weak var taskNumOfHours: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
