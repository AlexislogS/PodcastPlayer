//
//  PlayerChartView.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 16.08.2021.
//

import SwiftUI

struct PlayerChartView: View {
  
  let values: [Int]
  
  @Binding var playTime: Float
  
  var body: some View {
    GeometryReader { reader in
      HStack(alignment: .bottom) {
        ForEach(0..<values.count) { value in
          let max = values.max() ?? 0
          let width = (reader.size.width / CGFloat(values.count + 1))
          let delta = Float(values.count) * playTime
          Capsule()
            .foregroundColor(.accentColor)
            .frame(width: width, height: CGFloat(values[value]) / CGFloat(max) * reader.size.height)
            .opacity(Float(value) > delta ? 0.5 : 1)
        }
      }
      .frame(maxWidth: reader.size.width, maxHeight: .infinity)
    }
  }
}

struct ChartView_Previews: PreviewProvider {
  static var previews: some View {
    PlayerChartView(values: [213, 343, 3, 3, 344, 435, 342, 30, 213, 343, 3, 3, 344, 435, 342, 30, 213, 343, 3, 3, 344, 435, 342, 30, 213, 343, 3], playTime: .constant(0))
  }
}
