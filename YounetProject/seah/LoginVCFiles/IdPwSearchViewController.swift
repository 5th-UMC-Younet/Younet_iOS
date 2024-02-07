//
//  IdPwSearchViewController.swift
//  YounetProject
//
//  Created by 김세아 on 1/22/24.
//

import UIKit

class IdPwSearchViewController: UIViewController {
    
    @IBOutlet weak var iIdSearchButton: UIButton!
    @IBOutlet weak var idLineView: UIView!
    @IBOutlet weak var pwSearchButton: UIButton!
    @IBOutlet weak var pwLineView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var btnLists : [UIButton] = []
    var lineLists : [UIView] = []
    var currentIndex : Int = 0 {
        didSet {
            changeBtnColor()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setBtnList()
        setKeyboard()
    }

    func setBtnList() {
        iIdSearchButton.tintColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
        idLineView.backgroundColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
        pwSearchButton.tintColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
        pwLineView.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
        
        btnLists.append(iIdSearchButton)
        btnLists.append(pwSearchButton)
        lineLists.append(idLineView)
        lineLists.append(pwLineView)
    }
    
    func changeBtnColor() {
        for (index, element) in btnLists.enumerated() {
            if index == currentIndex {
                element.tintColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
                lineLists[index].backgroundColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
                confirmButton.setTitle("인증번호 확인", for: .normal)
            } else {
                element.tintColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
                lineLists[index].backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
                confirmButton.setTitle("아이디 찾기", for: .normal)
            }
        }
    }
    
    var pageViewController : PageViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // page VC
        if segue.identifier == "PageVCSegue" {
            guard let vc = segue.destination as? PageViewController else { return }
            pageViewController = vc
            pageViewController.completeHandler = { (result) in
                self.currentIndex = result
            }
        }
    }
    
    @objc private func openPopup(){
        // 팝업 여는 함수
        let presentedPopup = PopupViewController.present(parent: self)
        presentedPopup.onDismissed = { [weak self] () in
            self?.gotoRootVC() }
    }
    
    private func gotoRootVC() {
        // 초기 로그인 화면으로 화면 전환
        // 아래 코드는 warning 발생, memory leak 없음
        /*self.view.window?.rootViewController?.dismiss(animated: false, completion: {
            let newVC = LoginViewController()
            newVC.modalTransitionStyle = .crossDissolve
            newVC.modalPresentationStyle = .fullScreen
            self.present(newVC, animated: true, completion: nil)
        })*/
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        newVC.modalTransitionStyle = .crossDissolve
        newVC.modalPresentationStyle = .fullScreen
        self.present(newVC, animated: true, completion: nil)
    }
    
    @IBAction func IdSearchButtonDidTap(_ sender: Any) {
        pageViewController?.setViewcontrollersFromIndex(index: 0)
    }
    
    @IBAction func PwSearchButtonDidTap(_ sender: Any) {
        pageViewController?.setViewcontrollersFromIndex(index: 1)
    }
    
    @IBAction func confirmButtonDidtap(_ sender: Any) {
        if confirmButton.titleLabel?.text == "아이디 찾기" {
            // 이름과 이메일 주소 인증 성공
            
            let getId = "아이디샘플"
            let idSucceedPopup = PopupViewController.present(parent: self)
            idSucceedPopup.labelText = "\n회원님의 아이디는\n'\(getId)'입니다.\n"
            idSucceedPopup.onDismissed = { [weak self] () in
                self?.gotoRootVC() }
            // 이름과 이메일 주소 인증 실패
            // let idFailPopup = PopupViewController.present(parent: self)
            // idFailPopup.onDismissed = { [weak self] () in self?.gotoRootVC() }
        } else if confirmButton.titleLabel?.text == "인증번호 확인"{
            // 아이디 인증번호 검증 성공
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "PwResetVC") as? PwResetViewController else { return }
            nextVC.modalPresentationStyle = .fullScreen
            nextVC.modalTransitionStyle = .crossDissolve
            self.present(nextVC, animated: true, completion: nil)
            // 아이디 인증번호 검증 실패
            // 실패 시의 Popup
        } else { return }
    }
    
    @IBAction func backBtnDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
