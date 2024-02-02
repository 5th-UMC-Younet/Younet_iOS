//
//  IdentificationVC.swift
//  YounetProject
//
//  Created by 김제훈 on 1/21/24.
//

import UIKit

class IdentificationVC: UIViewController
{
    @IBOutlet var fileuploadButton: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        config()
    }
    
    private func config() 
    {
        // fileuploadButton
        fileuploadButton.translatesAutoresizingMaskIntoConstraints = false
        fileuploadButton.clipsToBounds = true
        fileuploadButton.layer.cornerRadius = fileuploadButton.frame.height / 2
        fileuploadButton.addTarget(self, action: #selector(openSelectNationPopup), for: .touchUpInside)
    }
    
    @objc
    private func openSelectNationPopup(){
        let presentedPopup = NationSelectionVC.present(parent: self)
        presentedPopup.onDismissed = {
            print(#fileID, #function, #line, "- DISMISSED")
            print(#fileID, #function, #line, "- \(presentedPopup.selectedCountry)")
        }
        
        
    }
    
}
