//
//  SearchBar.swift
//  CyBus
//
//  Created by Vadim Popov on 30/12/2024.
//

import SwiftUI
import ComposableArchitecture

struct SearchBarView : View {
    @Environment(\.theme) var theme
    @Bindable var store: StoreOf<SearchFeatures>
    
    var body: some View {
        HStack {
            Button {
                store.send(.onOpenAutoComplete)
            } label: {
                Text("Search here")
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(theme.colors.textFieldBackground)
                    .cornerRadius(12)
            }
            
            Spacer()
            
            Button {
                store.send(.onOpenFavourites)
            } label: {
                Image(systemName: "bookmark.fill")
                    .padding(12)
                    .background(theme.colors.textFieldBackground)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 14)
        .padding(.top, 6)
        .background(.white)
        .foregroundColor(theme.colors.linkTitle)
        .cornerRadius(12)
    }
    
}