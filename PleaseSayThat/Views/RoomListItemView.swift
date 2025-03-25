//
//  RoomListItemView.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//

import SwiftUI

// 방 목록 아이템 뷰
struct RoomListItemView: View {
    let room: AvailableRoom
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(room.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("\(room.memberCount)/\(room.maxMembers) members")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // 참여 가능 여부에 따른 아이콘
                if room.memberCount < room.maxMembers {
                    Image(systemName: "person.badge.plus")
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "person.fill.xmark")
                        .foregroundColor(.red)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(room.memberCount >= room.maxMembers)
        .opacity(room.memberCount >= room.maxMembers ? 0.6 : 1.0)
    }
}
