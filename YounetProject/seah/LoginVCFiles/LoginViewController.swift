//
//  LoginViewController.swift
//  YounetProject
//
//  Created by 김세아 on 1/7/24.
//

import UIKit
import KakaoSDKUser

class LoginViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboard()
        idTextField.delegate = self
    }
    
    @IBAction func joinBtnDidTap(_ sender: UIButton) {
        // 회원가입 VC 연결
        
        //테스트
        let nextSB = UIStoryboard(name: "Comunity", bundle: nil)
        guard let nextVC = nextSB.instantiateViewController(withIdentifier: "tabC") as? TabBarController else { return }
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func kakaoLoginBtnDidTap(_ sender: Any) {
        
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("카카오 로그인 성공")
                    
                    //accessToken값으로 서버 연결(get)
                    //연결 후 서버 토큰 및 expireTime 데이터 저장, 마이페이지 화면으로 전환
                    
                }
            }
        } else {
            //앱이 설치되어 있지 않은 경우에는 웹으로 로그인
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
               if let error = error {
                 print(error)
               }
               else {
                print("loginWithKakaoAccount() success.")
                
                //do something
                   _ = oauthToken
               }
            }
        }
    }
    
    @IBAction func loginBtnDidTap(_ sender: UIButton) {
        // 로그인 인증
        guard let idText = idTextField.text,
              let pwText = pwTextField.text else { return }
        
        LoginService.shared.signIn(id: idText, password: pwText) { (networkResult) -> (Void) in
            switch networkResult {
            case .success(let result):
                if let LoginUserData = result as? LoginUserData {
                    let tk = TokenUtils()
                    tk.create(APIUrl.url, account: "accessToken", value: LoginUserData.accessToken)
                    tk.create(APIUrl.url, account: "refreshToken", value: LoginUserData.refreshToken)
                    UserDefaults.standard.setValue(LoginUserData.accessTokenExpiresIn, forKey: "tokenExpireTime")
                    print("\(String(describing: tk.read(APIUrl.url, account: "accessToken")))")
                    
                    // MyPage로 화면 전환
                    let nextSB = UIStoryboard(name: "MyPage", bundle: nil)
                    guard let nextVC = nextSB.instantiateViewController(withIdentifier: "TabBarVC") as? UITabBarController else { return }
                    nextVC.modalPresentationStyle = .fullScreen
                    nextVC.modalTransitionStyle = .crossDissolve
                    self.present(nextVC, animated: true, completion: nil)
                }
            case .requestErr:
                let presentedPopup = PopupViewController.present(parent: self)
                presentedPopup.labelText = "\n비밀번호가 틀렸거나\n존재하지 않는 아이디입니다.\n"
                
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
