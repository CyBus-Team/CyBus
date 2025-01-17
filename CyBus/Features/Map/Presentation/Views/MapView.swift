//
//  MapView.swift
//  CyBus
//
//  Created by Vadim Popov on 07/07/2024.
//

import SwiftUI
import MapboxMaps
import ComposableArchitecture

struct MapView: View {
    
    @Bindable var mapStore: StoreOf<MapFeature>
    @Bindable var cameraStore: StoreOf<CameraFeature>
    @Bindable var locationStore: StoreOf<LocationFeature>
    @Bindable var busesStore: StoreOf<BusesFeature>
    @Bindable var searchStore: StoreOf<SearchFeatures>
    
    @Environment(\.theme) var theme
    
    private func onInit() {
        mapStore.send(.setUp)
        busesStore.send(.setUp)
        busesStore.send(.routes(.setUp))
    }
    
    var body: some View {
        
        NavigationStack {
            
            if mapStore.error != nil {
                VStack {
                    Text(mapStore.error ?? "Unknown error")
                    PrimaryButton(label:"Retry") {
                        onInit()
                    }
                }
                
            } else if mapStore.isLoading {
                VStack {
                    ProgressView()
                    Text("Loading...")
                }
                
            } else {
                ZStack {
                    
                    //MARK: - Map view
                    Map(viewport: $cameraStore.viewport) {
                        
                        //MARK: User location
                        Puck2D(bearing: .heading)
                            .showsAccuracyRing(true)
                        
                        //MARK: Buses
                        ForEvery(busesStore.groupedBuses) { busGroup in
                            MapViewAnnotation(coordinate: busGroup.position) {
                                BusGroup(
                                    activeBus: busesStore.selectedBusGroupState?.bus,
                                    buses: busGroup.buses,
                                    scale: cameraStore.scale
                                )
                                .onTapGesture {
                                    busesStore.send(.select(busGroup))
                                }
                            }
                            .variableAnchors([.init(anchor: .bottom)])
                            .allowOverlap(true)
                        }
                        
                        if busesStore.routes.hasSelectedRoute {
                            let route = busesStore.routes.selectedRoute
                            let stops = route?.stops ?? []
                            let shapes = route?.shapes ?? []
                            
                            //MARK: Stops
                            ForEvery(stops) { stop in
                                MapViewAnnotation(coordinate: stop.position) {
                                    StopCircle(color: theme.colors.primary).compositingGroup()
                                }
                                .allowZElevate(true)
                                .allowOverlap(true)
                            }
                            
                            //MARK: Shapes
                            PolylineAnnotation(
                                lineCoordinates: shapes.map { shape in
                                    shape.position
                                }
                            )
                            .lineColor(.systemBlue)
                            .lineWidth(3)
                        }
                        
                        if searchStore.searchAddressResult.detailedSuggestion?.location != nil {
                            MapViewAnnotation(coordinate: searchStore.searchAddressResult.detailedSuggestion!.location) {
                                Image(systemName: "mappin.circle.fill").resizable().scaledToFit().frame(width: 50, height: 50).foregroundColor(theme.colors.primary)
                            }.allowOverlap(true)
                        }
                    }
                    .mapStyle(.light)
                    .cameraBounds(CameraBoundsOptions(maxZoom: CameraFeature.maxZoom, minZoom: CameraFeature.minZoom))
                    
                    VStack {
                        Spacer()
                        HStack(alignment: .center) {
                            //MARK: - Navigation bar
                            
                            // MARK: Clear route button
                            if busesStore.hasSelection {
                                ClearRouteButton {
                                    busesStore.send(.clearSelection)
                                }
                            }
                            
                            //MARK: Zoom buttons
                            ZoomButton(
                                action: {
                                    cameraStore.send(.decreaseZoom)
                                },
                                zoomIn: false
                            )
                            ZoomButton(
                                action: {
                                    cameraStore.send(.increaseZoom)
                                },
                                zoomIn: true
                            )
                            
                            //MARK: Get current location button
                            LocationButton {
                                locationStore.send(.getCurrentLocation)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 20)
                    }
                    
                }
                .alert($mapStore.scope(state: \.alert, action: \.alert))
                .ignoresSafeArea()
            }
        }
        .onAppear() {
            onInit()
        }
        
    }
}

