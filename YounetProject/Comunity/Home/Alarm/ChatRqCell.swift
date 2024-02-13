//
//  ChatRqCell.swift
//  YounetProject
//
//  Created by 조혠 on 2/2/24.
//

import UIKit

class ChatRqCell: UITableViewCell {
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rejectButton.layer.cornerRadius = 5.0
        acceptButton.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func regect(_ sender: Any) {
    }
    @IBAction func accept(_ sender: Any) {
    }
    
    
}
