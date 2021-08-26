//
//  PlayerView.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 14.08.2021.
//

import SwiftUI
import AVKit
import MediaPlayer

struct PlayerView: View {
  
  @EnvironmentObject var podcastProvider: PodcastProvider
  
  let episode: Episode
  
  @State private var sliderPlayTime: Float = 0.0
  @State private var soundLevel: Float = 0.5
  @State private var isSliderTouching = false
  @State private var isPlaying = false
  @State private var rate: Float = 1.0
  @State private var player: AVPlayer?
  @State private var errorText: String?
  @State private var currentTime = "0:00"
  @State private var remainTime = "0:00"
  @State private var isReactionViewExpanded = false
  @State private var cardPosition = CardPosition.bottom
  @State private var reaction: String?
  @State private var emotion: Emotion?
  @State private var reactions: [Reaction]?
  @State private var defaultTimeStampEnd = 0
  @State private var statViewIsPresented = false
  
  var body: some View {
    ZStack {
      NavigationLink(destination: StatView(episode: emotion?.episodes.first(where: { $0.guid == episode.guid })),
                     isActive: $statViewIsPresented,
                     label: {})
      ZStack(alignment: .top) {
        ScrollView {
          if let url = URL(string: episode.imageURL) {
            ZStack {
              AsyncImage(url: url, size: CGSize(width: UIScreen.main.bounds.width * 0.7, height: 90), isFit: true).blur(radius: 60)
              AsyncImage(url: url, size: CGSize(width: 105, height: 105), isFit: true)
                .cornerRadius(15)
                .padding(.top, 80)
                .padding(.bottom)
            }
            Text(episode.title)
              .lineLimit(1)
              .foregroundColor(.white)
              .padding(.horizontal, 30)
            Text(episode.author)
              .foregroundColor(.accentColor)
              .padding(.bottom)
            VStack(spacing: 15) {
              PlayerChartView(values: [213, 343, 3, 3, 344, 435, 342, 30, 213, 343, 3, 3, 344, 435, 342, 30, 213, 343, 3, 3, 344, 435, 342, 30, 213, 343, 3], playTime: $sliderPlayTime)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 108, maxHeight: .infinity)
                .aspectRatio(308/108, contentMode: .fit)
                .padding(.horizontal, 100)
              SliderView(value: $sliderPlayTime, isSliderTouching: $isSliderTouching, soundLevel: false, completion: {
                guard let duration = player?.currentItem?.duration else { return }
                let durationInSeconds = CMTimeGetSeconds(duration)
                let seekTimeInSeconds = Float64(sliderPlayTime) * durationInSeconds
                let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
                player?.seek(to: seekTime)
              }).frame(height: 5)
              HStack {
                Text(currentTime)
                Spacer()
                HStack(spacing: 1) {
                  if sliderPlayTime != 0, sliderPlayTime != 1 {
                    Text("-")
                  }
                  Text(remainTime)
                }
              }
              .foregroundColor(Color("outline"))
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("chart")))
            .padding(.horizontal)
            HStack(spacing: 10) {
              Button(action: {
                switch rate {
                case 1:
                  rate = 1.5
                case 1.5:
                  rate = 2
                case 2:
                  rate = 0.5
                default:
                  rate = 1
                }
                player?.playImmediately(atRate: rate)
              }, label: {
                Text(String(rate) + "x")
                  .font(.system(size: 13, weight: .semibold, design: .default))
                  .lineLimit(1)
                  .padding(.vertical, 3)
                  .padding(.horizontal, 13)
                  .overlay(RoundedRectangle(cornerRadius: 14)
                            .stroke(Color("outline"), lineWidth: 1))
                  .fixedSize(horizontal: true, vertical: false)
              })
              Spacer()
              Button(action: {
                seekToCurrentTime(delta: -15)
              }, label: {
                Image("replay")
              })
              Button(action: {
                if player?.timeControlStatus == .playing {
                  player?.pause()
                  isPlaying = false
                } else {
                  if sliderPlayTime == 1 {
                    sliderPlayTime = 0
                    player?.seek(to: .zero)
                  }
                  player?.playImmediately(atRate: rate)
                  isPlaying = true
                }
              }, label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                  .resizable()
                  .frame(width: 45, height: 45, alignment: .center)
                  .padding()
              })
              Button(action: {
                seekToCurrentTime(delta: 15)
              }, label: {
                Image("forward")
              })
              Spacer()
              Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image("more")
              })
            }
            .padding(.horizontal, 5)
            .padding()
            .foregroundColor(.white)
            HStack(spacing: 0) {
              Image("minVolume")
              SliderView(value: $soundLevel, isSliderTouching: .constant(false), soundLevel: true)
                .frame(maxWidth: .infinity, maxHeight: 15)
                .offset(y: -1)
              Image("maxVolume")
            }.padding(.horizontal, 30)
          }
          Spacer().frame(width: 100, height: UIScreen.main.bounds.height * 0.4)
        }
        .opacity(cardPosition == .bottom ? 1 : 0.5)
        .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
        SlideOverCard(position: $cardPosition) {
          VStack {
            if let url = URL(string: episode.imageURL) {
              ReactionView(cardPosition: $cardPosition, emotion: $emotion, reactions: $reactions, imageURL: url)
            }
            Spacer()
          }.background(Color("background"))
          .cornerRadius(15)
          .padding(.vertical, 1).background(RoundedRectangle(cornerRadius: 15).strokeBorder().foregroundColor(.white).opacity(0.24))
        }.frame(height: UIScreen.main.bounds.height * 0.4)
      }
      if let reaction = reaction {
        Text(reaction)
          .font(.system(size: 100, weight: .regular, design: .default))
          .transition(.asymmetric(insertion: .scale, removal: .opacity))
      }
    }
    .navigationBarItems(trailing: Button(action: {
      statViewIsPresented = true
    }, label: {
      Image("analitics").imageScale(.large).padding()
    }))
    .onChange(of: soundLevel, perform: { value in
      MPVolumeView.setVolume(value)
    })
    .onReceive(podcastProvider.reaction, perform: { value in
      withAnimation {
        reaction = value
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        withAnimation {
          reaction = nil
        }
      }
    })
    .onReceive(NotificationCenter.default
                .publisher(for: .AVPlayerItemDidPlayToEndTime)) { _ in
      isPlaying = false
    }
    .onAppear() {
      emotion = podcastProvider.emotion
      reactions = emotion?.reactions ?? Reaction.getReactions()
      isReactionViewExpanded = true
      if let fileURL = URL(string: episode.fileURL) {
        do {
          try AVAudioSession.sharedInstance().setCategory(.playback)
          player = AVPlayer(url: fileURL)
          
          let interval = CMTimeMake(value: 1, timescale: 2)
          player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
            let currentTimeSeconds = CMTimeGetSeconds(time)
            if let episode = emotion?.episodes.first(where: { $0.guid == episode.guid }) {
              for reaction in episode.timed_reactions {
                if let min = Int(reaction.from),
                   let max = Int(reaction.to),
                   (min...max).contains(Int(currentTimeSeconds)),
                   let newReactions = emotion?.reactions.filter({ reaction.available_reactions.contains($0.reaction_id) }),
                   newReactions != reactions {
                  reactions = newReactions
                  defaultTimeStampEnd = max
                  break
                }
              }
              if defaultTimeStampEnd <= Int(currentTimeSeconds),
                 let newReactions = emotion?.reactions.filter({ episode.default_reactions.contains($0.reaction_id) }),
                 newReactions != reactions {
                reactions = newReactions
              }
            }
            let durationSeconds = CMTimeGetSeconds(player?.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
            self.currentTime = currentTimeSeconds.formatSecondsToString()
            self.remainTime = (durationSeconds - currentTimeSeconds).formatSecondsToString()
            if !isSliderTouching {
              let percentage = currentTimeSeconds / durationSeconds
              sliderPlayTime = Float(percentage)
            }
          }
        } catch let error {
          errorText = "Ошибка воспроизведения"
          print(error)
        }
      }
    }
    .onDisappear() {
      player?.pause()
      player = nil
    }
    .alert(isPresented: .constant(errorText != nil), content: {
      Alert(title: Text(errorText ?? ""),
            dismissButton: .default(Text("OK"), action: { errorText = nil })
      )
    })
    .background(Color("background"))
    .edgesIgnoringSafeArea(.top)
  }
  
  private func seekToCurrentTime(delta: Int64) {
    if let currentTime = player?.currentTime() {
      let seconds = CMTimeMake(value: delta, timescale: 1)
      let seekTime = CMTimeAdd(currentTime, seconds)
      player?.seek(to: seekTime)
    }
  }
}

struct PlayerView_Previews: PreviewProvider {
  static var previews: some View {
    PlayerView(episode: Episode(title: "title", author: "author", guid: "", pubDate: "", description: "", duration: "", fileURL: "", imageURL: "https://sun9-6.userapi.com/impf/k1ItkHXBu8UPzrqXiZoaA4fzqwhMLGTc1cP5zw/hdlvO9akdVk.jpg?size=1400x1400&amp;quality=96&amp;sign=505f65b68f018bf1316050ada0b36ca8&amp;type=none"))
  }
}
