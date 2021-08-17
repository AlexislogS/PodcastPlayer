//
//  Podcast.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 14.08.2021.
//

struct Podcast {
  let title: String
  let imageURL: String
  let episodes: [Episode]
}

struct Episode {
  let title: String
  let author: String
  let guid: String
  let pubDate: String
  let description: String
  let duration: String
  let fileURL: String
  let imageURL: String
}
