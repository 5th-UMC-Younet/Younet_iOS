//
//  PopupViewController.swift
//  YounetProject
//
//  Created by 김세아 on 2/3/24.
//

import UIKit

class PopupViewController: UIViewController
{
    @IBOutlet var closeBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    
    var labelText: String?
    var buttonText: String?
    var onDismissed : (() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        labelText != nil ? (textLabel.text = labelText) : nil
        buttonText != nil ? (confirmBtn.setTitle(buttonText, for: .normal)) : nil
    }

    private func config() {
        closeBtn.addTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
        confirmBtn.addTarget(self, action: #selector(confirmBtnClicked), for: .touchUpInside)
    }
    
    @objc private func closeBtnClicked(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: onDismissed)
    }
    
    @objc private func confirmBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: onDismissed)
    }
    
    @discardableResult
    class func present(parent: UIViewController) -> PopupViewController {
        let storyboard = UIStoryboard(name: "PopupViewController", bundle: .main)
        let vc = storyboard.instantiateInitialViewController() as! PopupViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        parent.present(vc, animated: true)
        return vc
    }
}
