//
//  StatView.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 18.08.2021.
//

import SwiftUI

struct StatView: View {
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Text("Реакции")
          .padding()
        HStack {
          Text("Динамика реакций на подкаст")
            .foregroundColor(Color("statText"))
          Spacer()
          Text("8%")
        }
      }
      .navigationBarTitle("Статистика")
      .padding()
    }
  }
}

struct StatView_Previews: PreviewProvider {
  static var previews: some View {
    StatView()
  }
}
