//
//  PodcastPlayerApp.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 13.08.2021.
//

import SwiftUI

@main
struct PodcastPlayerApp: App {
  
  @ObservedObject private var podcastProvider = PodcastProvider()
  
  init() {
    UIScrollView.appearance().keyboardDismissMode = .interactive
    
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default) //UIImage.init(named: "transparent.png")
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().isTranslucent = true
    UINavigationBar.appearance().tintColor = .white
  }
  
  var body: some Scene {
    WindowGroup {
      FeedView()
        .environmentObject(podcastProvider)
    }
  }
}
