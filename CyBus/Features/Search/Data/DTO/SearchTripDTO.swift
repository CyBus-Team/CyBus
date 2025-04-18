//
//  SearchTripDTO.swift
//  CyBus
//
//  Created by Vadim Popov on 18/01/2025.
//

struct SearchTripDTO: Codable {
    let id: String
    let stops: [String]
    let city: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case stops = "stops"
        case city = "city"
    }
}
