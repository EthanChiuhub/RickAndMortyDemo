//
//  RMService.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/7/20.
//
import Alamofire
import Combine
import Foundation

/// Primary API service object to get Rick and Morty data
final class RMService {
    /// Shared singletion instance
    static let shared = RMService()
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
        guard let urlRequest = self.request(from: request) else {
            return Fail(error: RMServiceError.failedToCreateRequest as! AFError).eraseToAnyPublisher()
        }
        return AF
            .request(urlRequest)
            .publishDecodable(type: type)
            .value().mapError { error in
                error
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
