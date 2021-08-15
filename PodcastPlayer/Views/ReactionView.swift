//
//  ReactionView.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 15.08.2021.
//

import SwiftUI

struct ReactionButton: View {
  
  let text: String
  
  @Binding var cardPosition: CardPosition
  
  var body: some View {
    Button(action: {
      cardPosition = .bottom
    }, label: {
      HStack {
        Text(text.components(separatedBy: "\n").first ?? "")
          .font(.system(size: UIScreen.main.bounds.width * 0.08, weight: .regular, design: .default))
        Text(text.components(separatedBy: "\n").last ?? "")
          .lineLimit(1)
          .minimumScaleFactor(0.3)
          .font(.system(size: UIScreen.main.bounds.width * 0.05, weight: .regular, design: .default))
      }
        .padding()
        .foregroundColor(.white)
        .background(RoundedRectangle(cornerRadius: 32).foregroundColor(Color("cover")))
    })
    .padding(1).background(RoundedRectangle(cornerRadius: 32).strokeBorder().foregroundColor(.white).opacity(0.24))
  }
}

struct ReactionRow: View {
  
  let textLeft: String
  let textRight: String
  
  @Binding var cardPosition: CardPosition
  
  var body: some View {
    HStack(spacing: 15) {
      ReactionButton(text: textLeft, cardPosition: $cardPosition)
      ReactionButton(text: textRight, cardPosition: $cardPosition)
    }
  }
}

struct ReactionView: View {
  
  @Binding var cardPosition: CardPosition
  
  let emotions = "😂👍👎😠🤪😎".map { String($0) }
  let imageURL: URL
  
  var body: some View {
    if cardPosition == .middle {
      VStack {
        Text("Реакции")
          .foregroundColor(.white)
          .font(.system(size: 20, weight: .semibold, design: .default))
          .padding(.vertical)
        ScrollView {
          VStack(alignment: .leading, spacing: 15) {
            ReactionRow(textLeft: "😂\nСмешно!", textRight: "👍\nОтлично", cardPosition: $cardPosition)
            ReactionRow(textLeft: "👎\nТак себе", textRight: "😠\nЗлюсь", cardPosition: $cardPosition)
            ReactionRow(textLeft: "😔\nГрустно", textRight: "☺️\nРадуюсь", cardPosition: $cardPosition)
            ReactionButton(text: "💸\nОпять реклама", cardPosition: $cardPosition)
            ReactionButton(text: "💩\nКакой-то бред", cardPosition: $cardPosition)
            Spacer().frame(width: 100, height: UIScreen.main.bounds.height * 0.33)
          }
          .frame(maxWidth: .infinity)
        }
      }
      .padding(.bottom, 20)
      .overlay(Button(action: {
        cardPosition = .bottom
      }, label: {
        Image(systemName: "xmark")
          .foregroundColor(Color("close"))
          .padding(8)
          .background(Circle().foregroundColor(Color("cover")))
      }).padding(), alignment: .topTrailing)
    } else {
      VStack {
        RoundedRectangle(cornerRadius: 25)
          .frame(width: 40, height: 4)
          .foregroundColor(.white).opacity(0.24)
          .padding(.top)
        Text("Реакции")
          .foregroundColor(.white)
          .font(.system(size: 20, weight: .semibold, design: .default))
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(spacing: 25) {
            ForEach(emotions, id: \.self) { item in
              Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text(item)
                  .font(.largeTitle)
                  .frame(width: UIScreen.main.bounds.width * 0.17, height: UIScreen.main.bounds.width * 0.17)
                  .background(Circle().foregroundColor(Color("cover")))
              })
              .padding(1).background(Circle().strokeBorder().foregroundColor(.white).opacity(0.24))
            }
          }.padding(.horizontal, 25)
        }.background(AsyncImage(url: imageURL, size: CGSize(width: UIScreen.main.bounds.width * 0.7, height: 90), isFit: true).blur(radius: 60))
        Spacer()
      }
      .frame(maxHeight: 190)
    }
  }
}

struct ReactionView_Previews: PreviewProvider {
  static var previews: some View {
    ReactionView(cardPosition: .constant(.bottom), imageURL: URL(string: "")!)
  }
}
