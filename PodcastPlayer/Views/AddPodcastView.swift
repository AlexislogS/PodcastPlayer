//
//  AddPodcastView.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 15.08.2021.
//

import SwiftUI

struct AddPodcastView: View {
  
  @Binding var podcastPath: String
  
  var body: some View {
    VStack {
      Text("Введите RSS адрес подкаста")
      TextField("", text: $podcastPath)
    }.padding(.horizontal, 30)
  }
}

struct AddPodcastView_Previews: PreviewProvider {
  static var previews: some View {
    AddPodcastView(podcastPath: .constant(""))
  }
}
