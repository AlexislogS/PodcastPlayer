//
//  PodcastProvider.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 13.08.2021.
//

import Foundation
import Combine

extension Publisher {
  func retryWithDelay<T, E>() -> Publishers.Catch<Self, AnyPublisher<T, E>> where T == Self.Output, E == Self.Failure {
    return self.catch { error -> AnyPublisher<T, E> in
      if (error as? URLError)?.code == .dataNotAllowed || (error as? URLError)?.code == .notConnectedToInternet || (error as? URLError)?.code == .badServerResponse {
        return Publishers.Delay(
          upstream: self,
          interval: 1,
          tolerance: 1,
          scheduler: RunLoop.main).retry(1).eraseToAnyPublisher()
      }
      return Publishers.Delay(
        upstream: self,
        interval: 1,
        tolerance: 1,
        scheduler: RunLoop.main).retry(.max).eraseToAnyPublisher()
    }
  }
}

class PodcastProvider: ObservableObject {
  
  let reaction = PassthroughSubject<String, Never>()
  
  func fetchPodcast(urlPath: String) -> AnyPublisher<Podcast, Error> {
    guard let url = URL(string: urlPath) else { return Just(Podcast(title: "", imageURL: "", episodes: [])).setFailureType(to: Error.self).eraseToAnyPublisher() }
    return URLSession.shared
      .dataTaskPublisher(for: url)
      .mapError({ $0 })
      .receive(on: RunLoop.main)
      .tryMap(handlePodcastData)
      .retryWithDelay()
      .eraseToAnyPublisher()
  }
  
  private func handlePodcastData(data: Data, response: URLResponse) throws -> Podcast {
    switch (response as? HTTPURLResponse)?.statusCode {
    case 200:
      do {
        let rss = try XMLParser.parse(data: data)
        let title = rss.children.first?.children.first(where: { $0.name == "title"})?.text ?? ""
        let imageURL = rss.children.first?.children.first(where: { $0.name == "itunes:image" })?.attributes["href"] ?? ""
        let author = rss.children.first?.children.first(where: { $0.name == "itunes:author" })?.text ?? ""
        var podcasts = [Episode]()
        for element in rss.children.first?.children.filter({ $0.name == "item" }) ?? [] {
          if let title = element.children.first(where: { $0.name == "title" })?.text,
             let pubDate = element.children.first(where: { $0.name == "pubDate" })?.text,
             let description = element.children.first(where: { $0.name == "description" })?.children.first?.text,
             let duration = element.children.first(where: { $0.name == "itunes:duration" })?.text,
             let fileURL = element.children.first(where: { $0.name == "enclosure" })?.attributes["url"],
             let imageURL = element.children.first(where: { $0.name == "itunes:image" })?.attributes["href"] {
            podcasts.append(Episode(title: title, author: author, pubDate: pubDate, description: description, duration: duration, fileURL: fileURL, imageURL: imageURL))
          }
        }
        return Podcast(title: title, imageURL: imageURL, episodes: podcasts)
      } catch let error {
        throw error
      }
    default:
      throw URLError(.badServerResponse)
    }
  }
  
}
