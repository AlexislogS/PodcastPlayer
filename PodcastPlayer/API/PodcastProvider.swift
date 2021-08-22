//
//  PodcastProvider.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 13.08.2021.
//

import Foundation
import Combine

class PodcastProvider: ObservableObject {
  
  let reaction = PassthroughSubject<String, Never>()
  
  @Published var emotion: Emotion?
  
  init() {
    emotion = load("podcast.json")
  }
  
  func fetchPodcast(urlPath: String) -> AnyPublisher<Podcast, Error> {
    guard let url = URL(string: urlPath) else { return Just(Podcast(title: "", imageURL: "", episodes: [])).setFailureType(to: Error.self).eraseToAnyPublisher() }
    return URLSession.shared
      .dataTaskPublisher(for: url)
      .mapError({ $0 })
      .receive(on: RunLoop.main)
      .tryMap(handlePodcastData)
      .removeDuplicates(by: { podcast1, podcast2 in
        podcast1.episodes.map { $0.guid } == podcast2.episodes.map { $0.guid }
      })
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
             let guid = element.children.first(where: { $0.name == "guid" })?.text,
             let pubDate = element.children.first(where: { $0.name == "pubDate" })?.text,
             let description = element.children.first(where: { $0.name == "description" })?.children.first?.text,
             let duration = element.children.first(where: { $0.name == "itunes:duration" })?.text,
             let fileURL = element.children.first(where: { $0.name == "enclosure" })?.attributes["url"],
             let imageURL = element.children.first(where: { $0.name == "itunes:image" })?.attributes["href"] {
            podcasts.append(Episode(title: title, author: author, guid: guid, pubDate: pubDate, description: description, duration: duration, fileURL: fileURL, imageURL: imageURL))
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
  
  private func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
      fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
      data = try Data(contentsOf: file)
    } catch {
      fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
      let decoder = JSONDecoder()
      return try decoder.decode(T.self, from: data)
    } catch {
      fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
  }

  
}
