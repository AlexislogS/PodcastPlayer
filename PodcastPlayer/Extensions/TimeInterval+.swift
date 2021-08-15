//
//  TimeInterval+.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 15.08.2021.
//

import Foundation

extension TimeInterval {
  
  func formatSecondsToString() -> String {
    if self.isNaN {
      return "0:00"
    }
    let Min = Int(self / 60)
    let Sec = Int(self.truncatingRemainder(dividingBy: 60))
    return String(format: "%2d:%02d", Min, Sec)
  }
}
