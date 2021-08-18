//
//  StatView.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 18.08.2021.
//

import SwiftUI

struct StatHeader: View {
  
  var body: some View {
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
  }
}

struct StatReactionRow: View {
  
  let emotion: String
  let description: String
  let value: Double
  
  var body: some View {
    HStack(spacing: 8) {
      Image("check")
      Text(emotion)
      Text(description)
        .foregroundColor(.white)
      Circle().foregroundColor(.accentColor).frame(width: 6, height: 6)
      Spacer()
      Text(String(value) + "K")
        .foregroundColor(Color("statText"))
    }
  }
}

struct StatPieResult: View {
  
  let text: String
  let value: Double
  let amount: String
  
  var body: some View {
    VStack {
      HStack {
        Circle().foregroundColor(Color("pie")).frame(width: 8, height: 8)
        HStack {
          Text(amount)
            .font(.system(size: 17, weight: .regular, design: .default))
          Text("· \(String(format: "%.0f", value))%")
            .foregroundColor(Color("statText"))
        }
        .foregroundColor(.white)
        .lineLimit(1)
        .minimumScaleFactor(0.3)
      }
      Text(text)
        .foregroundColor(Color("statText"))
        .font(.system(size: 13, weight: .regular, design: .default))
    }
  }
}

struct EmotionAgeRow: View {
  
  let age: String
  let emotions: String
  let firstValue: CGFloat
  let lastValue: CGFloat
  
  var body: some View {
    GeometryReader { reader in
      HStack(spacing: 5) {
        HStack {
          Text(age)
          Text(emotions)
        }
        .font(.system(size: 17, weight: .regular, design: .default))
        .lineLimit(1)
        .foregroundColor(.white)
        Spacer()
        VStack(alignment: .leading) {
          HStack {
            Capsule()
              .foregroundColor(Color("pie"))
              .frame(width: firstValue * reader.size.width * 0.3, height: 5)
            Text(String(format: "%.0f", Double(firstValue * 100)) + "%")
              .foregroundColor(Color("statText"))
          }
          HStack {
            Capsule()
              .foregroundColor(Color("stat"))
              .frame(width: lastValue * reader.size.width * 0.3, height: 5)
            Text(String(format: "%.0f", Double(lastValue * 100)) + "%")
              .foregroundColor(Color("statText"))
              .fixedSize(horizontal: true, vertical: false)
          }
        }
      }
    }
  }
}

struct StatView: View {
  
  @State private var reactionsExpanded = false
  
  let data: [DataPoint] = (2...25).map { DataPoint(value: Double($0 * Int.random(in: 10...100)), color: Color("stat")) }
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 8) {
        StatHeader()
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
        Group {
          Text("Данные сравниваются за одинаковые промежутки времени в прошлом")
            .foregroundColor(.white)
            .padding(.bottom)
          Divider().frame(height: 1)
            .padding(.bottom)
          Text("Пол и возраст")
            .padding(.bottom)
            .foregroundColor(.white)
          PieChart(dataPoints: [DataPoint(value: 15.4, color: Color("pie")),
                                DataPoint(value: 84.6, color: Color("stat"))])
            .frame(height: 164)
            .padding(.bottom)
        HStack(spacing: 8) {
          StatPieResult(text: "Мужчины", value: 15.4, amount: "8,4K")
          Spacer()
          StatPieResult(text: "Женщины", value: 84.6, amount: "18,4K")
        }.padding(.horizontal, 30)
        Divider().frame(height: 1)
          .padding(.bottom)
        EmotionAgeRow(age: "до 18", emotions: "👍👎😎", firstValue: 0.5, lastValue: 1)
          .padding(.bottom)
        }
        Text("Данные сравниваются за одинаковые промежутки времени в прошлом")
          .font(.system(size: 13, weight: .regular, design: .default))
          .foregroundColor(Color("statText"))
          .padding(.bottom)
        Divider().frame(height: 1)
          .padding(.bottom)
      }.padding(.bottom, UIScreen.main.bounds.height < 600 ? 100 : 140)
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
