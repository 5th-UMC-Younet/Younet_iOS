//
//  DefaultUnderlineTextField.swift
//  YounetProject
//
//  Created by 김제훈 on 2/15/24.
//

import UIKit

class DefaultUnderlineTextField: UIView
{
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var inputHairlineView: UIView!
 
    let onEditingColor = UIColor(red: 41/255, green: 29/255, blue: 137/255, alpha: 1)
    let onNotEditingColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.config()
    }
    
    func getCount() -> Int 
    {
        return inputTextField.text?.count ?? 0
    }
    
    func setAction(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        inputTextField.addTarget(target, action: action, for: controlEvents)
    }
    
    private func config()
    {
        self.applyNib()
        
        self.inputTextField.delegate = self
    }
    
    private func applyNib()
    {
        print(#fileID, #function, #line, "- ")
        let nibName = String(describing: Self.self)
        let nib = Bundle.main.loadNibNamed(nibName, owner: self)
        guard let view = nib?.first as? UIView else {
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

extension DefaultUnderlineTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        inputHairlineView.backgroundColor = onEditingColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if (inputHairlineView.backgroundColor?.cgColor == onEditingColor.cgColor)
        {
            inputHairlineView.backgroundColor = onNotEditingColor
        }
        
    }
}
