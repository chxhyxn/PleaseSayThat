//
//  ContentView.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 30) {
            // App logo or title
            Image(systemName: "person.3.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Room Chat")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
                .frame(height: 50)
            
            // Create room button
            Button(action: {
                
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Create Room")
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 280, height: 60)
                .background(Color.blue)
                .cornerRadius(15)
            }
            
            // Join room button
            Button(action: {
                
            }) {
                HStack {
                    Image(systemName: "person.badge.plus.fill")
                    Text("Join Room")
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 280, height: 60)
                .background(Color.green)
                .cornerRadius(15)
            }
            
            Spacer()
        }
        .padding()
    }
}
