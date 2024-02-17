//
//  SearchCell.swift
//  YounetProject
//
//  Created by 조혠 on 2/6/24.
//

import UIKit

class SearchCell: UITableViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var contentLabel1: UILabel!
    @IBOutlet weak var contentLabel2: UILabel!
    @IBOutlet weak var timeLabel1: UILabel!
    @IBOutlet weak var timeLabel2: UILabel!
    @IBOutlet weak var likeLabel1: UILabel!
    @IBOutlet weak var likeLabel2: UILabel!
    @IBOutlet weak var commentLabel1: UILabel!
    @IBOutlet weak var commentLabel2: UILabel!
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
