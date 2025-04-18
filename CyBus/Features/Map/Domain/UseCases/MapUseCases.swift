//
//  MapUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 04/09/2024.
//

import Foundation
import ComposableArchitecture
import MapboxMaps

enum MapUseCasesError: Error {
    case initializationFailed
}

class MapUseCases : MapUseCasesProtocol {
    private let bundle: Bundle
    
    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }
    
    func setup() throws {
        if let mapBoxAccessToken = bundle.object(forInfoDictionaryKey: "MBXAccessToken") as? String {
            MapboxOptions.accessToken = mapBoxAccessToken
        } else {
            throw MapUseCasesError.initializationFailed
        }
    }
    
}
