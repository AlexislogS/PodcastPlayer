//
//  PieChart.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 18.08.2021.
//

import SwiftUI

struct PieSegment: Shape, Identifiable {
  let data: DataPoint
  var id: Int { data.id }
  var startAngle: Double
  var amount: Double
  
  var animatableData: AnimatablePair<Double, Double> {
    get { AnimatablePair(startAngle, amount) }
    set {
      startAngle = newValue.first
      amount = newValue.second
    }
  }
  
  func path(in rect: CGRect) -> Path {
    let radius = min(rect.width, rect.height) / 2
    let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
    
    var path = Path()
    path.move(to: center)
    path.addRelativeArc(center: center, radius: radius, startAngle: Angle(radians: startAngle), delta: Angle(radians: amount))
    return path
  }
}

struct PieChart: View {
  let pieSegments: [PieSegment]
  let strokeWidth: Double?
  
  init(dataPoints: [DataPoint], strokeWidth: Double? = nil) {
    self.strokeWidth = strokeWidth
    
    var segments = [PieSegment]()
    let total = dataPoints.reduce(0) { $0 + $1.value }
    var startAngle = -Double.pi / 2
    
    for data in dataPoints {
      let amount = .pi * 2 * (data.value / total)
      let segment = PieSegment(data: data, startAngle: startAngle, amount: amount)
      segments.append(segment)
      startAngle += amount
    }
    
    pieSegments = segments
  }
  
  @ViewBuilder var mask: some View {
    if let strokeWidth = strokeWidth {
      Circle().strokeBorder(Color.white, lineWidth: CGFloat(strokeWidth))
    } else {
      Circle()
    }
  }
  
  var body: some View {
    ZStack {
      ForEach(pieSegments) { segment in
        segment
          .fill(segment.data.color)
      }
    }
    .mask(mask)
  }
}
