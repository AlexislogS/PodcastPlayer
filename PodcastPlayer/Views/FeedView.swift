//
//  FeedView.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 13.08.2021.
//

import SwiftUI
import Combine

struct FeedCell: View {
  
  let item: Episode
  
  var body: some View {
    NavigationLink(
      destination: PlayerView(episode: item),
      label: {
        HStack {
          if let url = URL(string: item.imageURL) {
            AsyncImage(url: url, size: CGSize(width: 105, height: 105), isFit: true)
          }
          VStack(alignment: .leading) {
            Text(item.title)
              .font(.body)
              .fontWeight(.semibold)
              .lineLimit(2)
            Spacer()
            Text(item.duration)
              .font(.callout)
              .foregroundColor(.accentColor)
          }.padding()
        }
      })
  }
}

struct FeedView: View {
  
  @EnvironmentObject var podcastProvider: PodcastProvider
  
  @State private var errorText: String?
  @State private var podcast: Podcast?
  @State private var addPodcastPresented = false
  @State private var podcastPath = "https://vk.com/podcasts-147415323_-1000000.rss"
  
  var body: some View {
    NavigationView {
      VStack {
        Text("Введите RSS адрес")
          .font(.title2)
          .fontWeight(.semibold)
          .foregroundColor(.accentColor)
          .padding(.top)
          .zIndex(1.0)
        TextField("URL", text: $podcastPath)
          .padding()
          .zIndex(1.0)
        Rectangle().frame(height: 1)
          .offset(y: -20)
          .padding(.horizontal)
          .zIndex(1.0)
        if let podcast = podcast {
          List {
            ForEach(podcast.episodes, id: \.title) { item in
              FeedCell(item: item)
            }
          }
          .offset(y: -20)
          .toolbar {
            ToolbarItem(placement: .principal) { // <3>
              VStack {
                Text(podcast.title).font(.headline)
                Text(String(podcast.episodes.count) + " эпизодов").font(.subheadline)
              }
            }
          }
          .listStyle(PlainListStyle())
          .navigationBarTitleDisplayMode(.inline)
        } else {
          ProgressView()
            .scaleEffect(1.5)
        }
      }
      .edgesIgnoringSafeArea(.bottom)
      .alert(isPresented: .constant(errorText != nil), content: {
        Alert(title: Text(errorText ?? ""),
              dismissButton: .default(Text("OK"), action: { errorText = nil })
        )
      })
      .onReceive(podcastProvider.fetchPodcast(urlPath: podcastPath).catch({ error -> AnyPublisher<Podcast, Error> in
        if (error as? URLError)?.code == .badServerResponse {
          errorText = "Сервер недоступен"
        }
        if (error as? URLError)?.code == .dataNotAllowed || (error as? URLError)?.code == .notConnectedToInternet {
          errorText = "Проверьте подключение к интернету"
        }
        return Just(Podcast(title: "", imageURL: "", episodes: [])).setFailureType(to: Error.self).eraseToAnyPublisher()
      }).assertNoFailure(), perform: { value in
        withAnimation(.easeIn) {
          self.podcast = value
        }
      })
      .navigationViewStyle(StackNavigationViewStyle())
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    FeedView()
  }
}
