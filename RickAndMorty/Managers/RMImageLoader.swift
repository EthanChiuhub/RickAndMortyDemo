//
//  RMImageLoader.swift
//  RickAndMorty
//
//  Created by Yi Chun Chiu on 2023/12/19.
//

import Combine
import UIKit

enum DownloadImageError: Error {
    case urlError
    case loadImageError
}

final class RMImageLoader {
    static let shared = RMImageLoader()

    private var imageDataCache = NSCache<NSString, NSData>()

    private init() {}

    /// Get image content with URL
    /// - Parameters:
    ///   - url: SOurce url
    ///   - completion: Callback
    func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString

        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data))
            return
        }

        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}
