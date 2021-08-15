//
//  SliderView.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 15.08.2021.
//

import UIKit
import SwiftUI

struct SliderView: UIViewRepresentable {
  
  final class Coordinator: NSObject {
    var value: Binding<Float>
    var isSliderTouching: Binding<Bool>
    var completion: (() -> Void)?
    
    init(value: Binding<Float>, isSliderTouching: Binding<Bool>, completion: (() -> Void)?) {
      self.value = value
      self.isSliderTouching = isSliderTouching
      self.completion = completion
    }
    
    @objc func valueChanged(_ sender: UISlider) {
      self.value.wrappedValue = sender.value
    }
    
    @objc func touchUpInsideChanged(slider: UISlider, event: UIEvent) {
      if let touchEvent = event.allTouches?.first, touchEvent.phase == .ended {
        self.value.wrappedValue = slider.value
        isSliderTouching.wrappedValue = false
        completion?()
      }
    }
    
    @objc func touchDragInsideChanged(slider: UISlider, event: UIEvent) {
      isSliderTouching.wrappedValue = true
    }
  }
  
  @Binding var value: Float
  @Binding var isSliderTouching: Bool
  let soundLevel: Bool
  var completion: (() -> Void)?
  
  func makeUIView(context: Context) -> UISlider {
    let slider = UISlider()
    slider.isContinuous = false
    if soundLevel {
      slider.minimumTrackTintColor = UIColor(named: "gray")
      slider.maximumTrackTintColor = UIColor(named: "gray")?.withAlphaComponent(0.3)
    } else {
      let circleImage = makeCircleWith(size: CGSize(width: 15, height: 15),
                                       backgroundColor: UIColor(named: "AccentColor") ?? .white)
      slider.maximumTrackTintColor = UIColor(named: "AccentColor")?.withAlphaComponent(0.3)
      slider.setThumbImage(circleImage, for: .normal)
      slider.setThumbImage(circleImage, for: .highlighted)
    }
    slider.addTarget(
      context.coordinator,
      action: #selector(Coordinator.touchUpInsideChanged(slider:event:)),
      for: .touchUpInside
    )
    slider.addTarget(
      context.coordinator,
      action: #selector(Coordinator.touchDragInsideChanged(slider:event:)),
      for: .touchDragInside
    )
    slider.addTarget(
      context.coordinator,
      action: #selector(Coordinator.valueChanged(_:)),
      for: .valueChanged
    )
    return slider
  }
  
  func updateUIView(_ uiView: UISlider, context: Context) {
    uiView.value = value
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(value: $value, isSliderTouching: $isSliderTouching, completion: completion)
  }
  
  private func makeCircleWith(size: CGSize, backgroundColor: UIColor) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(backgroundColor.cgColor)
    context?.setStrokeColor(UIColor.clear.cgColor)
    let bounds = CGRect(origin: .zero, size: size)
    context?.addEllipse(in: bounds)
    context?.drawPath(using: .fill)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
}
