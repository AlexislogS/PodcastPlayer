//
//  BarChart.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 18.08.2021.
//

import Foundation
import SwiftUI

struct DataPoint: Identifiable {
  let id: Int
  let value: Double
  let color: Color
  let title: String
  
  init(value: Double, color: Color, title: String = "") {
    self.id = Int.random(in: 1..<Int.max)
    self.value = value
    self.color = color
    self.title = title
  }
  
  init(id: Int, value: Double, color: Color, title: String = "") {
    self.id = id
    self.value = value
    self.color = color
    self.title = title
  }
}

struct BarChart: View {
  let dataPoints: [DataPoint]
  let maxValue: Double
  
  init(dataPoints: [DataPoint]) {
    self.dataPoints = dataPoints
    
    let highestPoint = dataPoints.max { $0.value < $1.value }
    maxValue = highestPoint?.value ?? 1
  }
  
  var body: some View {
    VStack {
      HStack(spacing: 1) {
        ForEach(dataPoints) { data in
          Rectangle()
            .fill(data.color)
            .cornerRadius(2.5)
            .scaleEffect(y: CGFloat(data.value / maxValue), anchor: .bottom)
        }
      }
      HStack(spacing: 10) {
        ForEach(Array(dataPoints.enumerated()), id: \.offset) { (index, data) in
          Text(index.isMultiple(of: 3) || index == 0 || index == 23 ? String(index) : "")
            .lineLimit(1)
            .font(.caption)
            .padding(.bottom)
            .foregroundColor(Color("statText"))
        }
      }
    }
  }
}
