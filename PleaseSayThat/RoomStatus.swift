//
//  RoomStatus.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//

import SwiftUI

/// Room status enum representing different states of a room
enum RoomStatus: String, Codable, CaseIterable {
    case open       // Room is open and accepting new members
    case inProgress // Room activity is in progress
    case closed     // Room is closed and not accepting new members
    case pending    // Room is waiting to start
    case archived   // Room is archived (historical)
}
