//
//  MPVolumeView+.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 15.08.2021.
//

import MediaPlayer

extension MPVolumeView {
  static func setVolume(_ volume: Float) -> Void {
    let volumeView = MPVolumeView()
    let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
      slider?.value = volume
    }
  }
}
