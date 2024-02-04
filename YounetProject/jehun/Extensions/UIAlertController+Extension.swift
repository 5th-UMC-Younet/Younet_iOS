//
//  UIAlertController+Extension.swift
//  YounetProject
//
//  Created by 김제훈 on 1/14/24.
//

import UIKit

enum AlertSelector: String {
    case YES = "예"
    case NO = "아니오"
}

extension UIAlertController
{
    static func presentAlert(_ vc: UIViewController, msg: String, btnMsg: String = "닫기", onConfirmClicked: (()->Void)? = nil)
    {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(btnMsg, comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
            onConfirmClicked?()
        }))
        
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func presentAlert1(_ vc: UIViewController? = nil, onBtnClicked: ((AlertSelector) -> Void)? = nil, msg: String)
    {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString(AlertSelector.YES.rawValue, comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
            onBtnClicked?(.YES)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString(AlertSelector.NO.rawValue, comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
            onBtnClicked?(.NO)
        }))
        
        if let vc = vc 
        {
            vc.present(alert, animated: true, completion: nil)
        }
        else
        {
            UIApplication.shared.rootVC?.present(alert, animated: true, completion: nil)
        }
    }
    
    static func presentAlert2(_ vc: UIViewController & UITableViewDataSource, onBtnClicked: ((AlertSelector) -> Void)? = nil, msg: String)
    {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { tf in
            
            let searchBtn = UIButton(type: .system)
            searchBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            tf.rightViewMode = .always
            tf.rightView = searchBtn
        })
 
        alert.addChild(UIViewController())
        
//        let rect = CGRect(x: 0.0, y: 0.0, width: alert.view.bounds.width, height: 50.0)
//        
//        var label = UILabel(frame: rect)
//        label.text = "NVVVHVH"
//        
//        alert.view.addSubview(label)
        
//        alert.preferredContentSize = rect.size
//        
//        var tableView = UITableView(frame: rect)
//        tableView.dataSource = vc
//        tableView.separatorStyle = .singleLine
//        alert.view.addSubview(tableView)
//        alert.view.bringSubviewToFront(tableView)
//        alert.view.isUserInteractionEnabled = true
//        tableView.isUserInteractionEnabled = true
    

//        tableView.delegate = vc
//        tableView.dataSource = vc
//        tableView.backgroundColor = UIColor.systemGreen
//        
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        alert.view.addSubview(tableView)
        
        
//        alert.addTextField()
//        
//        alert.textFields.first
        
        
        alert.addAction(UIAlertAction(title: NSLocalizedString(AlertSelector.YES.rawValue, comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
            onBtnClicked?(.YES)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString(AlertSelector.NO.rawValue, comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
            onBtnClicked?(.NO)
        }))
        
        vc.present(alert, animated: true, completion: nil)
//        if let vc = vc
//        {
//            vc.present(alert, animated: true, completion: nil)
//        }
//        else
//        {
//            UIApplication.shared.rootVC?.present(alert, animated: true, completion: nil)
//        }
    }
}
