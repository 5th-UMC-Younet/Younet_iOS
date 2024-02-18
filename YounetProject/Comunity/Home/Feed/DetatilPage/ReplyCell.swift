//
//  ReplyCell.swift
//  YounetProject
//
//  Created by 조혠 on 2/18/24.
//

import UIKit

class ReplyCell: UITableViewCell {
    @IBOutlet weak var userName: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
