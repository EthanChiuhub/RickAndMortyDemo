//
//  RMService.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/7/20.
//
import Alamofire
import Combine

/// Primary API service object to get Rick and Morty data
final class RMService {
    /// Shared singletion instance
    static let shared = RMService()
    
    private let cacheManager = RMAPICacheManager()
    
    var cancellables = Set<AnyCancellable>()

    
    /// Privatized constructor
    private init() {}
    enum RMServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: The type of object we expect to get back
    ///   - completion: Callback with data or error
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type
    ) -> Future<T, Error> {
        if let cachedData = cacheManager.cachedResponse(
            for: request.endpoint,
            url: request.url
        ) {
            do {
                let result = try JSONDecoder().decode(type.self, from: cachedData)
                print("Using cached API Response")
                return Future { promise in
                    promise(.success(result))
                }
            } catch  {
                return Future { promise in
                    promise(.failure(error))
                }
            }
        }
        guard let urlRequest = self.request(from: request) else {
            return Future { promise in
                promise(.failure(RMServiceError.failedToCreateRequest))
            }
        }
        return Future<T, Error> { promise in
               AF.request(urlRequest)
                   .publishDecodable(type: type)
                   .value()
                   .sink(
                       receiveCompletion: { completion in
                           switch completion {
                           case .finished:
                               break // Do nothing for success
                           case .failure(let error):
                               promise(.failure(error))
                           }
                       },
                       receiveValue: { value in
                           promise(.success(value))
                           // If needed, you can also set the cache here
                           print(value)
//                           self.cacheManager.setCache(for: request.endpoint, url: request.url, data: value)
                       }
                   )
                   .store(in: &self.cancellables)
           }
    }
    
    // MARK: - Private
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
}
