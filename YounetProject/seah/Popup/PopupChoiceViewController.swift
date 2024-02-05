//
//  PopupChoiceViewController.swift
//  YounetProject
//
//  Created by 김세아 on 2/4/24.
//

import UIKit

class PopupChoiceViewController: UIViewController
{
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var labelText: String?
    var titleText: String?
    var confirmText: String?
    var rejectText: String?
    
    var rejectDismissed: (() -> Void)? = nil
    var confirmDismissed: (() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        labelText != nil ? (textLabel.text = labelText) : nil
        titleText != nil ? (titleLabel.text = titleText) : nil
        confirmText != nil ? (confirmBtn.setTitle(confirmText, for: .normal)) : nil
        rejectText != nil ? (rejectBtn.setTitle(rejectText, for: .normal)) : nil
    }

    private func config() {
        closeBtn.addTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
        confirmBtn.addTarget(self, action: #selector(confirmBtnClicked), for: .touchUpInside)
        rejectBtn.addTarget(self, action: #selector(rejectBtnClicked), for: .touchUpInside)
    }
    
    @objc private func closeBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func confirmBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: confirmDismissed)
    }
    
    @objc private func rejectBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: rejectDismissed)
    }
    
    @discardableResult
    class func present(parent: UIViewController) -> PopupChoiceViewController {
        let storyboard = UIStoryboard(name: "PopupChoiceViewController", bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopupChoiceViewController") as! PopupChoiceViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        parent.present(vc, animated: true)
        return vc
    }
}
