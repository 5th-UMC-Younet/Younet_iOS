//
//  SceneDelegate.swift
//  YounetProject
//
//  Created by 김제훈 on 1/5/24.
//

import UIKit
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // 분기 처리를 통한 로그인 유지 구현
        if UserDefaults.standard.string(forKey: "tokenExpireTime") != nil {
            if (Date().timeIntervalSince1970 * 1000) < UserDefaults.standard.double(forKey: "tokenExpireTime") {
                // 토큰 만료시간이 지나지 않은 경우 -> 로그인 처리(마이페이지로 이동)
                let storyboard = UIStoryboard(name: "MenuSelectionVC", bundle: nil)
                let startVC = storyboard.instantiateViewController(withIdentifier: "NavigationVC") as? UINavigationController
                window?.rootViewController = startVC
                print(TokenUtils().read(APIUrl.url, account: "accessToken")!)
            } else {
                //토큰 만료시간이 지난 경우 -> refresh 토큰 활용해 토큰 재발급
                RefreshTokenService.shared.refreshToken(refreshToken: (TokenUtils().read(APIUrl.url, account: "refreshToken"))!){ (networkResult) -> (Void) in
                    switch networkResult {
                    case .success(let result):
                        // 서버 통한 재발급 성공 시 -> userDefaults에 만료시간 재저장, 로그인 처리(마이페이지로 이동)
                        if let LoginUserData = result as? LoginUserData {
                            let tk = TokenUtils()
                            tk.create(APIUrl.url, account: "accessToken", value: LoginUserData.accessToken)
                            tk.create(APIUrl.url, account: "refreshToken", value: LoginUserData.refreshToken)
                            UserDefaults.standard.setValue(LoginUserData.accessTokenExpiresIn, forKey: "tokenExpireTime")
                            print("토큰 만료로 재발급 완료")
                            print(tk.read(APIUrl.url, account: "accessToken")!)
                            let storyboard = UIStoryboard(name: "MenuSelectionVC", bundle: nil)
                            let startVC = storyboard.instantiateViewController(withIdentifier: "NavigationVC") as? UINavigationController
                            self.window?.rootViewController = startVC
                        }
                    case .requestErr:
                        // 400 오류로 서버 통한 재발급 실패 시 -> 미로그인 처리(로그인 페이지로 이동)
                        print("requestErr")
                        print("400 error: 토큰 재발급 실패")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let startVC = storyboard.instantiateViewController(withIdentifier: "LoginNaviVC") as? UINavigationController
                        self.window?.rootViewController = startVC
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
            // 토큰 만료시간이 저장되지 않은 경우(로그아웃, 회원탈퇴, 최초 로그인인 경우) -> 미로그인 처리(로그인 페이지로 이동)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let startVC = storyboard.instantiateViewController(withIdentifier: "LoginNaviVC") as? UINavigationController
            window?.rootViewController = startVC
        }

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    
}

