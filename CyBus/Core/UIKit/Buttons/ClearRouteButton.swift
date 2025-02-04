//
//  ClearRouteButton.swift
//  CyBus
//
//  Created by Vadim Popov on 03/08/2024.
//

import SwiftUI

struct ClearRouteButton: View {
    @Environment(\.theme) var theme
    
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 24))
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
    }
}

#Preview {
    ClearRouteButton(action: {
        print("Clear")
    })
}

