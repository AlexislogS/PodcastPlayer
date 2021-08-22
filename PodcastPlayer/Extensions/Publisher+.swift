//
//  Publisher+.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 22.08.2021.
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
