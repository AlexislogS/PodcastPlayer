//
//  ImageLoader.swift
//  PodcastPlayer
//
//  Created by Alex Yatsenko on 14.08.2021.
//

import UIKit
import Combine

public class ImageLoader: ObservableObject {
  
  private var destinationLock = pthread_rwlock_t()
  private var destinations: [URL:AnyPublisher<UIImage, Error>] = [:]
  
  private func handleResponse(task: URLSessionTask, response: URLResponse) -> Bool {
    guard (task.originalRequest?.url) != nil else { return false }
    return true
  }
  
  private func cacheURL(for url: URL) throws -> URL {
    let fm = FileManager.default
    let cacheDir = try fm.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    var components: [String] = ["ImageLoaderCache"]
    if let h = url.host { components.append(h) }
    for p in url.pathComponents.filter({ !$0.isEmpty && $0 != "/" }) { components.append(p) }
    return cacheDir.appendingPathComponent(components.joined(separator: "/"))
  }
  
  private func storeCache(url: URL, data: Data) {
    let fm = FileManager.default
    do {
      let u = try cacheURL(for: url)
      if !fm.fileExists(atPath: u.deletingLastPathComponent().path) {
        try fm.createDirectory(at: u.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
      }
      try data.write(to: u, options: [.atomic])
    } catch let e {
      print(url, e)
    }
  }

  public func hasCache(for url: URL) -> Bool {
    guard !url.isFileURL else { return true }
    guard let curl = try? cacheURL(for: url) else { return false }
    let fm = FileManager.default
    return fm.fileExists(atPath: curl.path)
  }

  public func load(url: URL) -> AnyPublisher<UIImage, Error> {
    let fm = FileManager.default
    let turl: URL
    if !url.isFileURL, let curl = try? cacheURL(for: url), fm.fileExists(atPath: curl.path) {
      turl = curl
    } else {
      turl = url
    }
    
    pthread_rwlock_rdlock(&destinationLock)
    if let op = destinations[turl] {
      defer { pthread_rwlock_unlock(&destinationLock) }
      return op
    }
    pthread_rwlock_unlock(&destinationLock)

    pthread_rwlock_wrlock(&destinationLock)
    defer { pthread_rwlock_unlock(&destinationLock) }
    
    if let op = destinations[turl] {
      return op
    } else {
      var urlRequest: URLRequest
      urlRequest = URLRequest(url: turl)
      let op = URLSession.shared
        .dataTaskPublisher(for: urlRequest)
        .mapError({ fail in fail })
        .receive(on: RunLoop.main)
        .tryMap(handleLoadData)
        .tryCatch({ [self] error -> AnyPublisher<UIImage, Error> in
          pthread_rwlock_wrlock(&destinationLock)
          defer { pthread_rwlock_unlock(&destinationLock) }
          destinations.removeValue(forKey: turl)
          throw error
        })
        .share()
        .eraseToAnyPublisher()
      destinations[turl] = op
      return op
    }
  }
  
  private func handleLoadData(data: Data, response: URLResponse) throws -> UIImage {
    pthread_rwlock_wrlock(&destinationLock)
    defer { pthread_rwlock_unlock(&destinationLock) }
    if response.url?.isFileURL == true || (response as? HTTPURLResponse)?.statusCode == 200 {
      guard let img = UIImage(data: data) else {
        throw URLError(.cannotDecodeContentData)
      }
      if let url = response.url {
        pthread_rwlock_wrlock(&destinationLock)
        defer { pthread_rwlock_unlock(&destinationLock) }
        destinations[url] = Just(img).setFailureType(to: Error.self).eraseToAnyPublisher()
        if !url.isFileURL {
          storeCache(url: url, data: data)
        }
      }
      return img
    }
    throw URLError(.badServerResponse)
  }
}
