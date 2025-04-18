//
//  SearchTripRepositoryLocal.swift
//  CyBus
//
//  Created by Vadim Popov on 18/01/2025.
//

import Foundation

class SearchTripRepositoryLocal: SearchTripRepositoryProtocol {
    private let bundle: Bundle
    private let tripsPath: String
    private let stopsPath: String
    private let citiesPath: String
    
    init(bundle: Bundle = .main, tripsPath: String = "all_trips", stopsPath: String = "trip_stops", citiesPath: String = "cities") {
        self.bundle = bundle
        self.tripsPath = tripsPath
        self.stopsPath = stopsPath
        self.citiesPath = citiesPath
    }
    
    func getTrips() async throws -> [SearchTripDTO] {
        guard let bundleData = bundle.url(forResource: tripsPath, withExtension: "json") else {
            throw TripSearchRepositoryError.fileNotFound
        }
        let data = try Data(contentsOf: bundleData)
        let decodedData = try JSONDecoder().decode([SearchTripDTO].self, from: data)
        return decodedData
    }
    
    func getStops() async throws -> [SearchStopDTO] {
        guard let bundleData = bundle.url(forResource: stopsPath, withExtension: "json") else {
            throw TripSearchRepositoryError.fileNotFound
        }
        let data = try Data(contentsOf: bundleData)
        let decodedData = try JSONDecoder().decode([SearchStopDTO].self, from: data)
        return decodedData
    }
    
    func getCities() throws -> [CityDTO] {
        guard let bundleData = bundle.url(forResource: citiesPath, withExtension: "json") else {
            throw TripSearchRepositoryError.fileNotFound
        }
        let data = try Data(contentsOf: bundleData)
        let decodedData = try JSONDecoder().decode([CityDTO].self, from: data)
        return decodedData
    }
    
}
