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
    ) -> AnyPublisher<T, AFError> {
        if let cachedData = cacheManager.cachedResponse(
            for: request.endpoint,
            url: request.url
        ) {
//            do {
//                let result = try JSONDecoder().decode(type.self, from: cachedData)
//                print("Using cached API Response")
//                return Future { promise in
//                    promise(.success(result))
//                }
//            } catch  {
//                return Future { promise in
//                    promise(.failure(error))
//                }
//            }
        }
        guard let urlRequest = self.request(from: request) else {
            return Fail(error: RMServiceError.failedToCreateRequest as! AFError).eraseToAnyPublisher()
        }
        
        return AF
            .request(urlRequest)
            .publishDecodable(type: type)
            .value().mapError { error in
                return AFError.requestAdaptationFailed(error: error)
            }.eraseToAnyPublisher()

    }
    
    // MARK: - Private
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
}
