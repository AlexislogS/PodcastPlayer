//
//  ReactionView.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 15.08.2021.
//

import SwiftUI

struct ReactionButton: View {
  
  @EnvironmentObject var podcastProvider: PodcastProvider
  
  let text: String
  
  @Binding var cardPosition: CardPosition
  
  var body: some View {
    Button(action: {
      podcastProvider.reaction.send(text.components(separatedBy: "\n").first ?? "")
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
      if textRight != "\n" {
        ReactionButton(text: textRight, cardPosition: $cardPosition)
      }
    }
  }
}

struct ReactionView: View {
  
  @EnvironmentObject var podcastProvider: PodcastProvider
  
  @Binding var cardPosition: CardPosition
  @Binding var emotion: Emotion?
  @Binding var reactions: [Reaction]?
  
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
            if let reaction = reactions?[unsafe: 0] {
              ReactionRow(textLeft: "\(reaction.emoji)\n\(reaction.description)", textRight: "\(reactions?[unsafe: 1]? .emoji ?? "")\n\(reactions?[unsafe: 1]? .description ?? "")", cardPosition: $cardPosition)
            }
            if let reaction = reactions?[unsafe: 2] {
              ReactionRow(textLeft: "\(reaction.emoji)\n\(reaction.description)", textRight: "\(reactions?[unsafe: 3]? .emoji ?? "")\n\(reactions?[unsafe: 3]? .description ?? "")", cardPosition: $cardPosition)
            }
            if let reaction = reactions?[unsafe: 4] {
              ReactionRow(textLeft: "\(reaction.emoji)\n\(reaction.description)", textRight: "\(reactions?[unsafe: 5]? .emoji ?? "")\n\(reactions?[unsafe: 5]? .description ?? "")", cardPosition: $cardPosition)
            }
            if let reaction = reactions?[unsafe: 6] {
              ReactionButton(text: "\(reaction.emoji)\n\(reaction.description)", cardPosition: $cardPosition)
            }
            if let reaction = reactions?[unsafe: 7] {
              ReactionButton(text: "\(reaction.emoji)\n\(reaction.description)", cardPosition: $cardPosition)
            }
            Spacer().frame(width: 100, height: UIScreen.main.bounds.height * 0.33)
          }
          .frame(maxWidth: .infinity)
          .padding(.horizontal)
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
            ForEach(reactions?.map { $0.emoji } ?? [], id: \.self) { item in
              Button(action: {
                podcastProvider.reaction.send(item)
              }, label: {
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
    ReactionView(cardPosition: .constant(.bottom), emotion: .constant(nil), reactions: .constant(nil), imageURL: URL(string: "")!)
  }
}
