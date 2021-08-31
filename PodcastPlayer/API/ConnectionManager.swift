//
//  ConnectionManager.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 31.08.2021.
//

import Foundation
import Network

class ConnectionManager: ObservableObject {
  
  private let monitor = NWPathMonitor()
  private let queue = DispatchQueue(label: "networkManager")
  
  @Published var isConnected = true
  
  init() {
    monitor.pathUpdateHandler = { path in
      DispatchQueue.main.async {
        self.isConnected = path.status == .satisfied
      }
    }
    monitor.start(queue: queue)
  }
}
