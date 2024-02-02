//
//  SearchResultTableViewCell.swift
//  YounetProject
//
//  Created by 김제훈 on 1/22/24.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
 
    
    @IBOutlet var nationTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.contentView.backgroundColor = .systemYellow.withAlphaComponent(0.5)
        } else {
            self.contentView.backgroundColor = .white
        }
    }
    
}
