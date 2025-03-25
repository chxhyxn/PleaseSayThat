//
//  AvailableRoom.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//

import SwiftUI

// 사용 가능한 방 모델
struct AvailableRoom: Identifiable {
    let id: UUID
    let name: String
    let memberCount: Int
    let maxMembers: Int
}
