//
//  UIVieweExtension.swift
//  YounetProject
//
//  Created by 김세아 on 1/6/24.
//

// UIView and UIViewController Extensions

import UIKit
import Alamofire

extension UIView {
    // 모서리 둥글게
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    
    
    // isHidden animation 구현
    func fadeIn(_ duration: TimeInterval = 0.2, onCompletion: (() -> Void)? = nil) { 
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration,
                       animations: { self.alpha = 1 },
                       completion: { (value: Bool) in
            if let complete = onCompletion { complete() }
        })
    }
    func fadeOut(_ duration: TimeInterval = 0.2, onCompletion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration,
                       animations: { self.alpha = 0 },
                       completion: { (value: Bool) in
            self.isHidden = true
            if let complete = onCompletion { complete() }
        })
    }
    
    
    
}

extension UIViewController{
    
    // 터치 시 키보드 내리기
    func setKeyboard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func checkExpireTime() {
        //매 화면전환마다 호출해서 시간 검사하고 지난경우에 다시 발급받게끔 하는 함수
        if (Date().timeIntervalSince1970 * 1000) > UserDefaults.standard.double(forKey: "tokenExpireTime") {
            //토큰 만료시간이 지난 경우 -> refresh 토큰 활용해 토큰 재발급
            RefreshTokenService.shared.refreshToken(refreshToken: (TokenUtils().read(APIUrl.url, account: "refreshToken"))!){ (networkResult) -> (Void) in
                switch networkResult {
                case .success(let result):
                    // 서버 통한 재발급 성공 시 -> userDefaults에 만료시간 및 토큰 재저장
                    if let LoginUserData = result as? LoginUserData {
                        let tk = TokenUtils()
                        tk.create(APIUrl.url, account: "accessToken", value: LoginUserData.accessToken)
                        tk.create(APIUrl.url, account: "refreshToken", value: LoginUserData.refreshToken)
                        UserDefaults.standard.setValue(LoginUserData.accessTokenExpiresIn, forKey: "tokenExpireTime")
                        print("토큰 만료로 재발급 완료")
                        print(tk.read(APIUrl.url, account: "accessToken")!)
                    }
                case .requestErr:
                    // 400 오류로 서버 통한 재발급 실패 시 -> 앱 종료 처리
                    print("requestErr")
                    print("400 error: 토큰 재발급 실패")
                    let popupVC = PopupViewController.present(parent: self)
                    popupVC.labelText = "\n서버 오류로 토큰 재발급에 실패했습니다.\n관리자에게 연락해주세요.\n"
                    popupVC.onDismissed = { UIApplication.shared.perform(
                        // suspend로 보낸 후 종료
                        #selector(NSXPCConnection.suspend))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            exit(0)
                        }
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
    }
    
}

extension UIResponder {
    
    private struct Static {
        static weak var responder: UIResponder?
    }
    
    static var currentResponder: UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }
    
    @objc private func _trap() {
        Static.responder = self
    }
}

extension UIImageView {
    // url로 이미지 설정하는 extension
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
}

extension UIImage {
    // 이미지 크기 조절을 위한 extension
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        print("화면 배율: \(UIScreen.main.scale)")// 배수
        print("origin: \(self), resize: \(renderImage)")
        return renderImage
    }
}
