//
//  StatusButton.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//

import SwiftUI

// Status button component
struct StatusButton: View {
    let image: String
    let title: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(image)
                .resizable()
                .scaledToFill()
        }
        .frame(minWidth: 200, maxWidth: 200, minHeight: 150, maxHeight: 150)
        .background(.white)
        .cornerRadius(8)
        .shadow(radius: 2, x: 1, y: 1)
        .buttonStyle(PlainButtonStyle())
    }
}
