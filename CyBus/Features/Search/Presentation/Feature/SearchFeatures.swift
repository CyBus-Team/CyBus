//
//  SearchFeatures.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import ComposableArchitecture

@Reducer
struct SearchFeatures {
    
    @ObservableState
    struct State: Equatable {
        // State vars
        var addressSearchOpened: Bool = false
        var addressResultOpened: Bool = false
        // Features
        var searchAddressResult = AddressSearchResultFeature.State()
        var searchAddress = AddressSearchFeature.State()
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onOpenAddressSearch
        case onOpenAddressSearchResults
        case onOpenFavourites
        case searchAddressResult(AddressSearchResultFeature.Action)
        case searchAddress(AddressSearchFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.searchAddress, action: \.searchAddress) {
            AddressSearchFeature()
        }
        Scope(state: \.searchAddressResult, action: \.searchAddressResult) {
            AddressSearchResultFeature()
        }
        BindingReducer()
        Reduce { state, action in
            switch action {
            // Search
            case .onOpenAddressSearch:
                state.addressSearchOpened = true
                state.addressResultOpened = false
                return .none
            case .onOpenAddressSearchResults:
                state.addressSearchOpened = false
                state.addressResultOpened = true
                return .none
            case .onOpenFavourites:
                return .none
            case .binding(_):
                return .none
            // Search suggestions
            case let .searchAddress(.onGetDetailedSuggestion(detailedSuggestion)):
                state.addressSearchOpened = false
                state.addressResultOpened = true
                return .run { send in
                    await send(.searchAddressResult(.setup(detailedSuggestion)))
                }
            case .searchAddress(_):
                return .none
            // Search results
            case .searchAddressResult(.onClose), .searchAddressResult(.binding(_)):
                state.addressResultOpened = false
                return .none
            case .searchAddressResult(_):
                return .none
            }
        }
    }
}