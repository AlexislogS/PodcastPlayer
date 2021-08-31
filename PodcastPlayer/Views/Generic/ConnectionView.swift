//
//  ConnectionView.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 31.08.2021.
//

import SwiftUI

struct ConnectionView: View {
  var body: some View {
    VStack {
      Image(systemName: "wifi.slash")
        .resizable()
        .scaledToFit()
        .frame(width: 200, height: 200)
        .foregroundColor(.accentColor)
      Text("Проверьте подключение к интернету")
        .foregroundColor(.accentColor)
      Button(action: {
        if let url = URL(string: "App-prefs:WIFI") {
          UIApplication.shared.open(url)
        }
      }, label: {
        Text("Настройки")
          .foregroundColor(.white)
          .padding()
          .font(.headline)
      })
      .frame(width: 140)
      .background(Color.accentColor)
      .clipShape(Capsule())
      .padding()
    }
  }
}

struct ConnectionView_Previews: PreviewProvider {
  static var previews: some View {
    ConnectionView()
  }
}
