//
//  TransitFeedRepository.swift
//  CyBus
//
//  Created by Vadim Popov on 22/08/2024.
//

import Foundation

enum BusesRepositoryError: Error {
    case GFTSNotFound
    case invalidURL
}

class BusesRepository: BusesRepositoryProtocol {
    
    private let urlSession: URLSession
    private let bundle: Bundle
    
    init(urlSession: URLSession, bundle: Bundle) {
        self.urlSession = urlSession
        self.bundle = bundle
    }
    
    func getServiceUrl() throws -> URL {
        guard let domain = Bundle.main.object(forInfoDictionaryKey: "GFTSServiceURL") as? String else {
            throw BusesRepositoryError.GFTSNotFound
        }
        guard let url = URL(string: "http://\(domain)") else {
            throw BusesRepositoryError.invalidURL
        }
        return url
    }
    
    func fetchBuses(url: URL) async throws -> [TransitRealtime_FeedEntity] {
        let (data, _) = try await urlSession.data(from: url)
        let feedMessage = try TransitRealtime_FeedMessage(serializedData: data)
        return feedMessage.entity
    }
}
