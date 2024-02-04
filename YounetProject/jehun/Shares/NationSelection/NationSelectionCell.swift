//
//  NationSelectionCell.swift
//  YounetProject
//
//  Created by 김제훈 on 2/2/24.
//

import UIKit

class NationSelectionCell: UITableViewCell
{
    @IBOutlet var countryName: UILabel!
    @IBOutlet var countryFlagImg: UIImageView!
    @IBOutlet var bgView: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        config()
    }

    private func config()
    {
        bgView.layer.cornerRadius = 10
        bgView.isHidden = true
    }
    
    func configCell(_ country: CountryDTO)
    {
        countryName.text = country.korName
        countryFlagImg.image = UIImage(named: country.engName)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        if (selected)
        {
            if (bgView.isHidden)
            {
                bgView.isHidden = false
            }
        }
        else
        {
            if (!(bgView.isHidden))
            {
                bgView.isHidden = true
            }
        }
        
        
    }
}

