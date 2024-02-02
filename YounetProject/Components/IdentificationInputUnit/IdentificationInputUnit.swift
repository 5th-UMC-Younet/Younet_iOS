//
//  IdentificationInputUnit.swift
//  YounetProject
//
//  Created by 김제훈 on 1/22/24.
//

import UIKit

class IdentificationInputUnit: UIStackView 
{
    @IBOutlet var inputTitleLabel: UILabel!
    @IBOutlet var inputTextField: UITextField!
    
    @IBInspectable
    var titleText: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.inputTitleLabel.text  = self.titleText
            }
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        config()
    }
    
    private func config()
    {
        applyNib()
        
        // inputTextField
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.layer.cornerRadius = 6
        inputTextField.layer.borderWidth = 0.8
        inputTextField.layer.borderColor = UIColor.black.cgColor
    }
    
    private func applyNib()
    {
        print(#fileID, #function, #line, "- ")
        let nibName = String(describing: Self.self)
        let nib = Bundle.main.loadNibNamed(nibName, owner: self)
        guard let view = nib?.first as? UIStackView else {
            return
        }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}

