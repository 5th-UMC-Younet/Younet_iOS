//
//  MyChatCell.swift
//  YounetProject
//
//  Created by 김제훈 on 2/6/24.
//

import UIKit

class MyChatCell: UITableViewCell {
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var chatTimestampLabel: UILabel!
    
    @IBOutlet var chatBubbleView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        if let labelContainer = contentLabel.superview {
//            labelContainer.round(corners: [ .bottomLeft, .bottomRight], radius: 25)
//        }
        
//        let maskPath = UIBezierPath(roundedRect: chatBubbleView.bounds,
//                                    byRoundingCorners: [.bottomLeft, .bottomRight],
//                    cornerRadii: CGSize(width: 25.0, height: 25.0))
//
//        let shape = CAShapeLayer()
//        shape.path = maskPath.cgPath
//        chatBubbleView.layer.mask = shape
//        chatBubbleView.round(corners: [.topLeft, .bottomLeft, .bottomRight], radius: 25)
//        chatBubbleView.layoutIfNeeded()
//        chatBubbleView.round(corners: [.bottomLeft], radius: 25)
//        chatBubbleView.round(corners: [.bottomRight], radius: 25)
    
        chatBubbleView.layer.cornerRadius = 25
    }
    
    // 
    func updateUI(data: Message){
        self.contentLabel.text = data.message
        self.chatTimestampLabel.text = data.timestampString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
