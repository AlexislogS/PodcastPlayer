//
//  PodcastPlayerApp.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 13.08.2021.
//

import SwiftUI
import VKSdkFramework

@main
struct PodcastPlayerApp: App {
  
  @Environment(\.openURL) var openURL
  @ObservedObject private var podcastProvider = PodcastProvider()
  @ObservedObject private var authManager = AuthManager()
  
  init() {
    UIScrollView.appearance().keyboardDismissMode = .interactive
    
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().isTranslucent = true
    UINavigationBar.appearance().tintColor = .white
  }
  
  var body: some Scene {
    WindowGroup {
      if authManager.authorized {
        FeedView()
          .environmentObject(authManager)
          .environmentObject(podcastProvider)
      } else {
        AuthView()
          .environmentObject(authManager)
          .onOpenURL { url in
            VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
          }
      }
    }
  }
}
