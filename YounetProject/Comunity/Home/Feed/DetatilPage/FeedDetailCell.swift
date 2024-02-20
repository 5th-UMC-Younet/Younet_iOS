//
//  FeedDetailCell.swift
//  YounetProject
//
//  Created by 조혠 on 1/23/24.
//

import UIKit

class FeedDetailCell: UITableViewCell {
    @IBOutlet weak var userName: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()    }
    @IBAction func reply(_ sender: Any) {
        print("답글")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
