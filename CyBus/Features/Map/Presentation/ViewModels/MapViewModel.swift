//
//  MapViewModel.swift
//  CyBus
//
//  Created by Vadim Popov on 07/07/2024.
//

import Foundation
import Combine

class MapViewModel: ObservableObject {
    @Published var buses: [BusEntity] = []
    @Published var selection: (bus: BusEntity, route: BusRouteEntity)?
    
    private let busesUsecases: BusesUseCasesProtocol
    private let routesUseCases: RoutesUseCasesProtocol
    
    private var timer: Timer?
    
    public var hasSelection: Bool {
        get { selection != nil }
    }
    
    init() {
        let bundle = Bundle.main
        let routesRepository = RoutesRepository(bundle: bundle)
        routesUseCases = RoutesUseCases(repository: routesRepository)
        busesUsecases = BusesUseCases(
            repository: BusesRepository(urlSession: URLSession.shared,bundle: bundle),
            routesUseCases: routesUseCases
        )
        
        self.startTimer()
    }
    
    deinit {
        stopTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { [weak self] in
                try await self?.fetchBuses()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @MainActor
    private func fetchBuses() async throws {
        do {
            let buses = try await busesUsecases.fetchBuses()
            self.buses = hasSelection ? buses.filter { $0 == selection?.bus } : buses
        } catch {
            print("Failed to fetch busses \(error)")
        }
        
        
    }
    
    func onSelectBus(bus: BusEntity) {
        let route = routesUseCases.getRoute(for: bus.routeID)
        selection = (bus, route)
    }
    
    func onMapLoaded() {
        Task {
            do {
                try busesUsecases.fetchServiceUrl()
                try await routesUseCases.fetchRoutes()
            } catch {
                print("Failed to load Map \(error)")
            }
        }
        
    }
    
    func onClearSelection()  {
        selection = nil
    }
}