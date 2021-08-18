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

struct ContentView: View {
  @State private var redAmount = Double.random(in: 10...100)
  @State private var yellowAmount = Double.random(in: 10...100)
  @State private var greenAmount = Double.random(in: 10...100)
  @State private var blueAmount = Double.random(in: 10...100)
  
  var data: [DataPoint] {
    [
      DataPoint(id: 1, value: redAmount, color: .red, title: "Yes"),
      DataPoint(id: 2, value: yellowAmount, color: .yellow, title: "Maybe"),
      DataPoint(id: 3, value: greenAmount, color: .green, title: "No"),
      DataPoint(id: 4, value: blueAmount, color: .blue, title: "N/A")
    ]
  }
  
  var body: some View {
    BarChart(dataPoints: data)
      .onTapGesture {
        withAnimation {
          redAmount = Double.random(in: 10...100)
          yellowAmount = Double.random(in: 10...100)
          greenAmount = Double.random(in: 10...100)
          blueAmount = Double.random(in: 10...100)
        }
      }
  }
}
