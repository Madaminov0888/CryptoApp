//
//  NetworkManager.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 21/10/23.
//

import Foundation
import Combine

class NetworkManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse: return "[] Bad response from URL."
            case .unknown: return "[] Unknown error"
            }
        }
    }
    
    static func downloadData(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try httpsResponseHandler(output: $0) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func httpsResponseHandler(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >=  200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse
        }
        return output.data
    }
    
    static func sinkHandler(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
