//
//  PopupTemplateVC.swift
//  YounetProject
//
//  Created by 김제훈 on 1/31/24.
//

import UIKit

class PopupTemplateVC: UIViewController
{
    @IBOutlet var closeBtn: UIButton!
    
    
    var onDismissed : (() -> Void)? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        config()
    }

    private func config() 
    {
        closeBtn.addTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
    }
    
    @objc
    private func closeBtnClicked(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: onDismissed)
    }
    
    @discardableResult
    class func present(parent: UIViewController) -> PopupTemplateVC {
        let storyboard = UIStoryboard(name: "PopupTemplateVC", bundle: .main)
        print(#fileID, #function, #line, "- \(storyboard)")
        let vc = storyboard.instantiateInitialViewController() as! PopupTemplateVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        parent.present(vc, animated: true)
        return vc
    }
}
