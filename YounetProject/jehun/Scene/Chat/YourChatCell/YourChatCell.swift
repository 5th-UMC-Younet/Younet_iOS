//
//  YourChatCell.swift
//  YounetProject
//
//  Created by 김제훈 on 2/6/24.
//

import UIKit

class YourChatCell: UITableViewCell {
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var chatTimestampLabel: UILabel!
    @IBOutlet var bubbleChatView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bubbleChatView.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(data: Message){
        self.contentLabel.text = data.message
        self.chatTimestampLabel.text = data.timestampString
    }
    
}
