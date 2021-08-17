//
//  Emotion.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 17.08.2021.
//

import Foundation

struct Reaction: Decodable, Equatable {
  let reaction_id: Int
  let emoji: String
  let description: String
}

struct TimedReactions: Decodable {
  let from: String
  let to: String
  let available_reactions: [Int]
}

struct EmotionEpisode: Decodable {
  let guid: String
  let default_reactions: [Int]
  let timed_reactions: [TimedReactions]
  let statistics: [Stat]?
}

struct Stat: Decodable {
  let time: Int
  let reaction_id: Int
  let sex: String
  let age: Int
  let city_id: Int
}

struct Emotion: Decodable {
  let reactions: [Reaction]
  let episodes: [EmotionEpisode]
}
