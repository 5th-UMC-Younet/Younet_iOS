//
//  IdPwSearchViewController.swift
//  YounetProject
//
//  Created by 김세아 on 1/22/24.
//

import UIKit

class IdPwSearchViewController: UIViewController {
    
    @IBOutlet weak var idSearchButton: UIButton!
    @IBOutlet weak var idLineView: UIView!
    @IBOutlet weak var pwSearchButton: UIButton!
    @IBOutlet weak var pwLineView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var mainStackView: UIStackView!
    
        
    var btnLists : [UIButton] = []
    var lineLists : [UIView] = []
    var currentIndex : Int = 0 {
        didSet {
            changeBtnColor()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
        setKeyboard()
    }
    
    private func setDesign() {
        idSearchButton.tintColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
        idLineView.backgroundColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
        pwSearchButton.tintColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
        pwLineView.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
        
        btnLists.append(idSearchButton)
        btnLists.append(pwSearchButton)
        lineLists.append(idLineView)
        lineLists.append(pwLineView)
        
        let screenHeight = UIScreen.main.bounds.size.height
        if screenHeight < 700 {
            topConstraint.constant = 80
            labelStackView.spacing = 45
            mainStackView.spacing = 20
        }
    }
    
    private func changeBtnColor() {
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
        // pageViewController 연결
        if segue.identifier == "PageVCSegue" {
            guard let vc = segue.destination as? PageViewController else { return }
            pageViewController = vc
            pageViewController.completeHandler = { (result) in
                self.currentIndex = result
            }
        }
    }
    
    private func gotoRootVC() {
        // 초기 로그인 화면으로 화면 전환
        // 아래 코드는 warning 발생, memory leak 없음
        self.view.window?.rootViewController?.dismiss(animated: false, completion: {
            let newVC = LoginViewController()
            newVC.modalTransitionStyle = .crossDissolve
            newVC.modalPresentationStyle = .fullScreen
            self.present(newVC, animated: true, completion: nil)
        })
        
        /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        newVC.modalTransitionStyle = .crossDissolve
        newVC.modalPresentationStyle = .fullScreen
        self.present(newVC, animated: true, completion: nil)*/
    }
    
    @IBAction func IdSearchButtonDidTap(_ sender: Any) {
        pageViewController?.setViewcontrollersFromIndex(index: 0)
    }
    
    @IBAction func PwSearchButtonDidTap(_ sender: Any) {
        pageViewController?.setViewcontrollersFromIndex(index: 1)
    }
    
    @IBAction func confirmButtonDidtap(_ sender: Any) {
        // 아이디 찾기
        if confirmButton.titleLabel?.text == "아이디 찾기" {
            if (UserDefaults.standard.string(forKey: "nameTf_idSearch") != nil) || (UserDefaults.standard.string(forKey: "emailTf_idSearch") != nil){
                let name = UserDefaults.standard.string(forKey: "nameTf_idSearch")!
                let email = UserDefaults.standard.string(forKey: "emailTf_idSearch")!
                
                FindIdService.shared.findId(name: name, email: email){ (networkResult) -> (Void) in
                    switch networkResult {
                    case .success(let result):
                        if let userId = result as? String {
                            // 기존 TextField 입력값 받아온 UserDefaults Data 삭제
                            UserDefaults.standard.removeObject(forKey: "nameTf_idSearch")
                            UserDefaults.standard.removeObject(forKey: "emailTf_idSearch")

                            // 인증번호 검증 성공 -> 로그인 페이지로 이동
                            let idSucceedPopup = PopupViewController.present(parent: self)
                            idSucceedPopup.labelText = "\n회원님의 아이디는\n'\(userId)'입니다.\n"
                            idSucceedPopup.onDismissed = { [weak self] () in
                                self?.gotoRootVC() }
                        }
                    case .requestErr:
                        // 아이디 찾기 실패 -> 실패 팝업 띄우기
                        let idFailedPopup = PopupViewController.present(parent: self)
                        idFailedPopup.labelText = "\n관련된 아이디가\n존재하지 않습니다.\n"
                        
                    case .pathErr:
                        print("pathErr")
                    case .serverErr:
                        print("serverErr")
                    case .networkFail:
                        print("networkFail")
                    }
                }
            } else {
                let tfUnfilledErrorPopup = PopupViewController.present(parent: self)
                tfUnfilledErrorPopup.labelText = "\n이름과 이메일\n모두 입력해주세요.\n"
            }
            // 비밀번호 찾기
        } else if confirmButton.titleLabel?.text == "인증번호 확인"{
            
            if (UserDefaults.standard.string(forKey: "idTf_pwSearch") != nil) || (UserDefaults.standard.string(forKey: "verifyNumTf_pwSearch") != nil){
                let idText = UserDefaults.standard.string(forKey: "idTf_pwSearch")!
                let codeText = UserDefaults.standard.string(forKey: "verifyNumTf_pwSearch")!
                
                EmailVerificationService.shared.verifyEmail(id: idText, code: codeText) { (networkResult) -> (Void) in
                    switch networkResult {
                    case .success(let result):
                        if let PwSearchUserData = result as? PwSearchUserData {
                            // 반환값으로 받아온 Id 저장 -> pw 수정 페이지에서 활용
                            let loginId = PwSearchUserData.loginId
                            
                            // 기존 TextField 입력값 받아온 UserDefaults Data 삭제
                            UserDefaults.standard.removeObject(forKey: "idTf_pwSearch")
                            UserDefaults.standard.removeObject(forKey: "verifyNumTf_pwSearch")

                            // 인증번호 검증 성공 -> 비밀번호 설정 페이지로 이동
                            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "PwResetVC") as? PwResetViewController else { return }
                            nextVC.modalPresentationStyle = .fullScreen
                            nextVC.modalTransitionStyle = .crossDissolve
                            nextVC.loginId = loginId
                            self.present(nextVC, animated: true, completion: nil)
                        }
                    case .requestErr(let msg):
                        if let message = msg as? String {
                            // 아이디 인증번호 검증 실패 -> 실패 팝업 띄우기
                            let pwFailedPopup = PopupViewController.present(parent: self)
                            pwFailedPopup.labelText = "\n\(message)\n"
                        }
                    case .pathErr:
                        print("pathErr")
                    case .serverErr:
                        print("serverErr")
                    case .networkFail:
                        print("networkFail")
                    }
                }
            }
        } else {
            let tfUnfilledErrorPopup = PopupViewController.present(parent: self)
            tfUnfilledErrorPopup.labelText = "\n아이디와 인증번호\n모두 입력해주세요.\n"
        }
    }
    
    @IBAction func backBtnDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        UserDefaults.standard.removeObject(forKey: "nameTf_idSearch")
        UserDefaults.standard.removeObject(forKey: "emailTf_idSearch")
        UserDefaults.standard.removeObject(forKey: "idTf_pwSearch")
        UserDefaults.standard.removeObject(forKey: "verifyNumTf_pwSearch")
    }
    
}
