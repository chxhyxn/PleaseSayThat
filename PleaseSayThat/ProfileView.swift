//
//  ProfileView.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//

import SwiftUI

struct ProfileView: View {
    // No need for @ObservedObject or @StateObject
    var body: some View {
        VStack {
            if let user = UserManager.shared.currentUser {
                Text("Hello, \(user.username)")
                // Other user-related UI...
            } else {
                Text("Please log in")
            }
        }
    }
}
