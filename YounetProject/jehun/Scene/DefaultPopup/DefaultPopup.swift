//
//  DefaultPopup.swift
//  YounetProject
//
//  Created by 김제훈 on 2/7/24.
//

import UIKit

class DefaultPopup: UIViewController 
{
    @IBOutlet var closeBtn: UIButton!
    @IBOutlet var normalBtn: UIButton!
    @IBOutlet var contentLabel: UILabel!
    
    
    var onDismissed : (() -> Void)? = nil
    
    private var contentStr: String = ""
    private var btnTitleStr: String = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print(#fileID, #function, #line, "- ⭐️\(contentLabel)")
        config()
    }

    private func config()
    {
        closeBtn.addTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
        normalBtn.addTarget(self, action: #selector(normalBtnClicked(_:)), for: .touchUpInside)
        self.setContentLabel(contentStr)
        self.setNormalBtnTitle(btnTitleStr)
    }

    @objc private func closeBtnClicked(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: onDismissed)
    }
    
    @objc private func normalBtnClicked(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: onDismissed)
    }
    
    @discardableResult
    class func present(parent: UIViewController, contentStr: String, btnTitleStr: String) -> DefaultPopup {
        let storyboard = UIStoryboard(name: "DefaultPopup", bundle: .main)
        print(#fileID, #function, #line, "- \(storyboard)")
        let vc = storyboard.instantiateInitialViewController() as! DefaultPopup
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.contentStr = contentStr
        vc.btnTitleStr = btnTitleStr
        
        parent.present(vc, animated: true)
        return vc
    }
    
    private func setContentLabel(_ contentStr: String)
    {
        contentLabel.text = contentStr
    }
    
    private func setNormalBtnTitle(_ titleStr: String)
    {
        normalBtn.setTitle(titleStr, for: .normal)
    }
}
