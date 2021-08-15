//
//  UINavigationController.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 14.08.2021.
//

import UIKit

extension UINavigationController {
  
  open override func viewWillLayoutSubviews() {
    navigationBar.topItem?.backButtonDisplayMode = .minimal
    view.backgroundColor = .clear
  }
  
}
