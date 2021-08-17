//
//  Array+.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 17.08.2021.
//

import Foundation

public extension Array {
  subscript(unsafe index: Index) -> Element? {
    get {
      guard indices.contains(index) else { return nil }
      return self[index]
    }
    set {
      guard indices.contains(index), let val = newValue else { return }
      self[index] = val
    }
  }
}
