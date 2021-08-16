//
//  ChartView.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 16.08.2021.
//

import SwiftUI

struct ChartView: View {
  
  let values: [Int]
  
  var body: some View {
    GeometryReader { reader in
      HStack(alignment: .bottom) {
        ForEach(0..<values.count) { value in
          let max = values.max() ?? 0
          
          RoundedRectangle(cornerRadius: 2.5)
            .foregroundColor(.accentColor)
            .frame(width: (reader.size.width / CGFloat(values.count + 1)) - 5, height: CGFloat(values[value]) / CGFloat(max) * reader.size.height)
        }
      }
//      .frame(maxWidth: .infinity)
    }
  }
}

struct ChartView_Previews: PreviewProvider {
  static var previews: some View {
    ChartView(values: [213, 343, 3,  3, 344, 435, 342, 30, 213, 343, 3,  3, 344, 435, 342, 30, 213, 343, 3,  3, 344, 435, 342, 30, 213, 343, 3])
  }
}
