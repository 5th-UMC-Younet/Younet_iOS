//
//  AppDelegate.swift
//  YounetProject
//
//  Created by 김제훈 on 1/5/24.
//

import UIKit
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var alarmNum = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KakaoSDK.initSDK(appKey: "774e929f589b038acd49775d44cd5ccc")
        
        // 앱 실행 시 사용자에게 알림 허용 권한을 받음
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        // 푸시 알림 허용 여부 판단
        NotificationCenter.default.addObserver(
              self,
              selector: #selector(checkNotificationSetting),
              name: UIApplication.willEnterForegroundNotification,
              object: nil
            )
       
        return true
    }
    
    @objc private func checkNotificationSetting() {
        
        UNUserNotificationCenter.current()
          .getNotificationSettings { permission in
            switch permission.authorizationStatus  {
            case .authorized:
              print("푸시 수신 동의")
                self.alarmNum = 1
            case .denied:
              print("푸시 수신 거부")
                self.alarmNum = 2
            case .notDetermined:
              print("한 번 허용 누른 경우")
            case .provisional:
              print("푸시 수신 임시 중단")
            case .ephemeral:
              // @available(iOS 14.0, *)
              print("푸시 설정이 App Clip에 대해서만 부분적으로 동의한 경우")
            @unknown default:
              print("Unknow Status")
            }
          }
      }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}
