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
  
  static func getReactions() -> [Reaction] {
    return [
      Reaction(reaction_id: 1, emoji: "😂", description: "Смешно!"),
      Reaction(reaction_id: 2, emoji: "👍", description: "Отлично"),
      Reaction(reaction_id: 3, emoji: "👎", description: "Так себе"),
      Reaction(reaction_id: 4, emoji: "😠", description: "Злюсь"),
      Reaction(reaction_id: 5, emoji: "😔", description: "Грустно"),
      Reaction(reaction_id: 6, emoji: "☺️", description: "Радуюсь"),
      Reaction(reaction_id: 7, emoji: "💸", description: "Опять реклама"),
      Reaction(reaction_id: 8, emoji: "💩", description: "Какой-то бред!")
    ]
  }
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
