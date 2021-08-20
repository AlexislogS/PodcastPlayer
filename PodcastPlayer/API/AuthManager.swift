//
//  AuthManager.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 20.08.2021.
//

import Foundation
import Combine
import VKSdkFramework

class AuthManager: NSObject, VKSdkDelegate, VKSdkUIDelegate, ObservableObject {
  
  @Published public private(set) var authorized: Bool = false
  
  let errorText = PassthroughSubject<String, Never>()
  
  private let appId = "7931643"
  private let vkSdk: VKSdk
  private var token: String?
  private let scope = ["offline"]
  
  override init() {
    vkSdk = VKSdk.initialize(withAppId: appId)
    super.init()
    vkSdk.register(self)
    vkSdk.uiDelegate = self
    wakeUPSession()
  }
  
  private func wakeUPSession() {
    let scope = ["offline"]
    VKSdk.wakeUpSession(scope) { state, error in
      if (error as? URLError)?.code == .badServerResponse {
        self.errorText.send("Сервер недоступен")
      }
      if (error as? URLError)?.code == .dataNotAllowed || (error as? URLError)?.code == .notConnectedToInternet {
        self.errorText.send("Проверьте подключение к интернету")
      }
      switch state {
      case .initialized:
        print("initialized")
      case .authorized:
        self.authorized = true
      default: break
      }
    }
  }
  
  func login() {
    VKSdk.authorize(scope)
  }
  
  func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
    if result.token != nil {
    
    } else {
      errorText.send("Произошла ошибка, попробуйте снова")
    }
  }
  
  func vkSdkUserAuthorizationFailed() {
    errorText.send("Произошла ошибка, попробуйте снова")
  }
  
  func vkSdkShouldPresent(_ controller: UIViewController!) {}
  
  func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {}
}
