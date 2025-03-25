//
//  RoomStatus.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//

import SwiftUI

/// Room status enum representing different states of a room
enum RoomStatus: String, Codable, CaseIterable {
    case base
    case niceTry
    case clap
    case breakTime
    case otherOpinion
    case organize
    case mountain
}
