//
//  MapUseCases.swift
//  CyBus
//
//  Created by Vadim Popov on 04/09/2024.
//

import Foundation
@_spi(Experimental) import MapboxMaps

enum MapUseCasesError: Error {
    case initializationFailed
}


class MapUseCases : MapUseCasesProtocol {
    private let bundle: Bundle
    
    init(bundle: Bundle) {
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