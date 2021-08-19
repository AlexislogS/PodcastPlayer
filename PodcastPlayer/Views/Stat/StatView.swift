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
      Text("8 %")
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
          Text("· \(String(format: "%.1f", value)) %")
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
  let firstValue: Double
  let lastValue: Double
  
  var body: some View {
    GeometryReader { reader in
      HStack(spacing: 5) {
        HStack {
          Text(age)
            .minimumScaleFactor(0.5)
          Text(emotions)
            .minimumScaleFactor(0.5)
        }
        .font(.system(size: 17, weight: .regular, design: .default))
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .foregroundColor(.white)
        Spacer().frame(width: 20, height: 1)
        VStack(alignment: .leading, spacing: 3) {
          HStack(spacing: 15) {
            Capsule()
              .foregroundColor(Color("pie"))
              .frame(width: CGFloat(firstValue) * reader.size.width * 0.3, height: 4)
            Text(String(format: "%.0f", Double(firstValue * 100)) + " %")
              .foregroundColor(Color("statText"))
              .font(.system(size: 11, weight: .regular, design: .default))
              .fixedSize(horizontal: true, vertical: false)
          }
          HStack(spacing: 15) {
            Capsule()
              .foregroundColor(Color("stat"))
              .frame(width: CGFloat(lastValue) * reader.size.width * 0.3, height: 4)
            Text(String(format: "%.1f", Double(lastValue * 100)) + " %")
              .foregroundColor(Color("statText"))
              .font(.system(size: 11, weight: .regular, design: .default))
              .fixedSize(horizontal: true, vertical: false)
          }
        }
      }
    }
  }
}

struct CityRowView: View {
  
  let city: String
  let amount: Double
  let value: Double
  let color: Color
  
  var body: some View {
    GeometryReader { reader in
      HStack(spacing: 15) {
        HStack(spacing: 5) {
          Text(city)
            .foregroundColor(.white)
            .font(.system(size: 15, weight: .regular, design: .default))
          Spacer()
          Text(String(amount) + "K")
            .foregroundColor(Color("statText"))
            .font(.system(size: 12, weight: .regular, design: .default))
            .fixedSize(horizontal: true, vertical: false)
        }
        HStack(spacing: 15) {
          ZStack(alignment: .leading) {
            Capsule()
              .foregroundColor(.clear)
              .frame(width: reader.size.width * 0.4, height: 4)
            Capsule()
              .foregroundColor(color)
              .frame(width: CGFloat(value) * reader.size.width * 0.4, height: 4)
          }
          Text(String(format: "%.1f", Double(value * 100)) + " %")
            .foregroundColor(Color("statText"))
            .font(.system(size: 11, weight: .regular, design: .default))
            .fixedSize(horizontal: true, vertical: false)
        }
      }.frame(maxWidth: .infinity)
    }
  }
}

struct StatView: View {
  
  struct Age {
    let id = UUID()
    let first: Int
    let last: Int
  }
  
  struct City {
    let id = UUID()
    let name: String
    let amount: Double
    let value: Double
    let color: Color
  }
  
  @State private var reactionsExpanded = false
  
  let episode: EmotionEpisode?
  let data: [DataPoint] = (2...25).map { DataPoint(value: Double($0 * Int.random(in: 10...100)), color: Color("stat")) }
  let ages: [Age] = [
    Age(first: 0, last: 17),
    Age(first: 18, last: 21),
    Age(first: 21, last: 24),
    Age(first: 24, last: 27),
    Age(first: 27, last: 30)
  ]
  let cities: [City] = [
    City(name: "Санкт-Петербург", amount: 1.4, value: 0.741, color: Color("pie")),
    City(name: "Москва", amount: 114, value: 0.074, color: Color("orange")),
    City(name: "Новосибирск", amount: 70, value: 0.017, color: Color("purple")),
    City(name: "Анадырь", amount: 17, value: 0.014, color: Color("blue")),
    City(name: "Витебск", amount: 4, value: 0.004, color: Color("green")),
    City(name: "Другие", amount: 147, value: 0.074, color: Color("white"))
  ]
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 8) {
        Group {
          StatHeader()
          BarChart(dataPoints: data)
            .frame(height: 150)
            .padding(.bottom, 10)
          Divider().frame(height: 1)
            .padding(.bottom)
          Text("Виды реакций")
            .padding(.bottom)
            .foregroundColor(.white)
        }
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
          .font(.system(size: 13, weight: .regular, design: .default))
          .foregroundColor(Color("statText"))
          .padding(.bottom)
        Group {
          Divider().frame(height: 1)
            .padding(.bottom)
          Text("Пол и возраст")
            .padding(.bottom)
            .foregroundColor(.white)
          PieChart(dataPoints: [DataPoint(value: maleAge, color: Color("pie")),
                                DataPoint(value: abs(1 - maleAge), color: Color("stat"))])
            .frame(height: 164)
            .padding(.bottom, 5)
        HStack(spacing: 8) {
          StatPieResult(text: "Мужчины", value: maleAge * 100, amount: "8,4K")
          Spacer()
          StatPieResult(text: "Женщины", value: abs(1 - maleAge) * 100, amount: "18,4K")
        }.padding(.horizontal, 30)
        Divider().frame(height: 1)
          .padding(.bottom)
          ForEach(ages, id: \.id) { age in
            EmotionAgeRow(age: age.id == ages.first?.id ? "до 18" : "\(age.first)-\(age.last)", emotions: "👍👎😎", firstValue: getAge(for: age.first...age.last, male: true), lastValue: getAge(for: age.first...age.last, male: false))
              .padding(.vertical, 10)
          }
        }
        .padding(.bottom)
        Text("Данные сравниваются за одинаковые промежутки времени в прошлом")
          .font(.system(size: 13, weight: .regular, design: .default))
          .foregroundColor(Color("statText"))
          .padding(.bottom)
        Group {
          Divider().frame(height: 1)
            .padding(.bottom, 5)
          HStack {
            Text("Города")
              .foregroundColor(.white)
            Image("arrow")
          }.padding(.bottom, 10)
          PieChart(dataPoints: cities.map { DataPoint(value: $0.value, color: $0.color) })
            .frame(height: 164)
            .padding(.bottom, 5)
          ForEach(cities, id: \.id) { city in
            CityRowView(city: city.name, amount: city.amount, value: city.value, color: city.color)
              .padding(.vertical)
          }
        }.padding(.bottom)
        Group {
          Text("Данные сравниваются за одинаковые промежутки времени в прошлом")
            .font(.system(size: 13, weight: .regular, design: .default))
            .foregroundColor(Color("statText"))
            .padding(.bottom)
          Divider().frame(height: 1)
          HStack {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
              Text("Данные за 30 дней")
              Image("arrow")
            })
          }.frame(maxWidth: .infinity, alignment: .center).padding(.vertical, 5)
          Divider().frame(height: 1)
        }
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
  
  private var maleAge: Double {
    if let total = episode?.statistics?.count,
       let males = episode?.statistics?.filter({ $0.sex == "male" }).count {
      return Double(males) / Double(total)
    }
    return 0.154
  }
  
  private func getAge(for range: ClosedRange<Int>, male: Bool) -> Double {
    if let total = episode?.statistics?.count,
       let ageCount = episode?.statistics?.filter({ range.contains($0.age) && $0.sex == (male ? "male" : "female") }).count {
      return Double(ageCount) / Double(total) * 10
    }
    return Double.random(in: (0...1))
  }
}

struct StatView_Previews: PreviewProvider {
  static var previews: some View {
    StatView(episode: nil)
  }
}
