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
    
    var isSelectedBefore: Bool = false
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        config()
    }

    private func config()
    {
        selectionStyle = .none
        bgView.layer.cornerRadius = 10
        bgView.isHidden = true
    }
    
    func configCell(_ country: CountryDTO, selected: CountryDTO?)
    {
        print(#fileID, #function, #line, "- \(country.engName), \(selected?.engName)")
        
        
        
        countryName.text = country.korName
        countryFlagImg.image = UIImage(named: country.engName)
        
        self.isSelectedBefore = selected != nil
        
        let selectedEngName = selected?.engName ?? ""
        
        let countryEngName = country.engName
        
        isSelectedBefore = selectedEngName == countryEngName
        print(#fileID, #function, #line, "- \(isSelectedBefore)")
//        self.setSelected(isSelectedBefore, animated: true)
        
        bgView.isHidden = !isSelectedBefore
        
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool)
//    {
//        print(#fileID, #function, #line, "- setSelected-\(isSelectedBefore )")
//        super.setSelected(selected, animated: animated)
//        
//        if isSelectedBefore {
//
//            return
//        }
//        
//        if (selected)
//        {
//            if (bgView.isHidden)
//            {
//                bgView.isHidden = false
//            }
//        }
//        else
//        {
//            if (!(bgView.isHidden))
//            {
//                bgView.isHidden = true
//            }
//        }
//        
//        
//    }
}

