//
//  AlarmCell.swift
//  YounetProject
//
//  Created by 조혠 on 1/13/24.
//

import UIKit

class AlarmCell: UITableViewCell {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var onDeleteButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func deleteAlarm(_ sender: Any) {
        onDeleteButtonTapped?()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
