//
//  StatView.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 18.08.2021.
//

import SwiftUI

struct StatReactionRow: View {
  
  let emotion: String
  let description: String
  let value: Double
  
  var body: some View {
    HStack(spacing: 8) {
      Image("check")
      Text(emotion)
      Text(description)
      Circle().foregroundColor(.accentColor).frame(width: 6, height: 6)
      Spacer()
      Text(String(value) + "K")
        .foregroundColor(Color("statText"))
    }
  }
}

struct StatView: View {
  
  @State private var reactionsExpanded = false
  
  var data: [DataPoint] = (2...25).map { DataPoint(value: Double($0 * Int.random(in: 10...100)), color: Color("stat"))}
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 8) {
        Divider().frame(height: 1)
          .padding(.bottom)
        Text("Реакции")
          .padding(.bottom)
          .foregroundColor(.white)
        HStack {
          Text("Динамика реакций на подкаст")
            .foregroundColor(Color("statText"))
          Spacer()
          Text("8%")
            .foregroundColor(.white)
        }
        .padding(.bottom)
        BarChart(dataPoints: data)
          .frame(height: 150)
          .padding(.bottom, 10)
        Divider().frame(height: 1)
          .padding(.bottom)
        Text("Виды реакций")
          .padding(.bottom)
          .foregroundColor(.white)
        ForEach(Reaction.getReactions().prefix(reactionsExpanded ? Reaction.getReactions().count : 4), id: \.reaction_id) { reaction in
          StatReactionRow(emotion: reaction.emoji, description: reaction.description, value: 0.5)
            .padding(.bottom)
        }
        Button {
          withAnimation(reactionsExpanded ? .easeIn : .easeOut) {
            reactionsExpanded.toggle()
          }
        } label: {
          HStack {
            Image("arrow")
              .rotationEffect(.degrees(reactionsExpanded ? 180 : 0))
            Text("Остальные реакции")
          }
        }.padding(.bottom)
        Text("Данные сравниваются за одинаковые промежутки времени в прошлом")
        Text("Пол и возраст")
          .padding(.bottom)
          .foregroundColor(.white)
      }
      .toolbar {
        ToolbarItem(placement: .principal) {
          VStack {
            Text("Статистика").font(.headline).foregroundColor(.white)
          }
        }
      }
      .padding()
    }.offset(y: UIScreen.main.bounds.height < 600 ? 60 : 90)
    .background(Color("background"))
    .edgesIgnoringSafeArea(.vertical)
  }
}

struct StatView_Previews: PreviewProvider {
  static var previews: some View {
    StatView()
  }
}
