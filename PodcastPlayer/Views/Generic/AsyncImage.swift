//
//  AsyncImage.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 14.08.2021.
//

import UIKit
import SwiftUI
import Combine

struct AsyncImage: View {
  
  @ObservedObject private var loader = ImageLoader()

  @State private var image: UIImage?
  
  let url: URL
  let size: CGSize
  let isFit: Bool
  
  init(url: URL, size: CGSize, isFit: Bool = false) {
    self.url = url
    self.size = size
    self.isFit = isFit
  }
  
  func load() -> AnyPublisher<UIImage, Never> {
    return loader.load(
      url: url
    ).catch({ error -> AnyPublisher<UIImage, Error> in
      print("Failed to load image", error)
      self.image = nil
      return Empty().eraseToAnyPublisher()
    }).assertNoFailure().eraseToAnyPublisher()
  }
  
  var body: some View {
    ZStack {
      Image(uiImage: image ?? UIImage())
        .resizable()
        .frame(width: size.width, height: size.height)
        .aspectRatio(contentMode: isFit ? .fit : .fill)
        .clipped()
        .onReceive(load()) { value in
          self.image = value
        }
        .redacted(reason: image == nil ? .placeholder : [])
      if image == nil {
        ProgressView()
      }
    }
  }
}
