//
//  RoomListItemView.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//

import SwiftUI

// 방 목록 아이템 뷰
struct RoomListItemView: View {
    let room: Room
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(room.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 12) {
                        Text("\(room.currentMemberCount)/\(room.maximumMemberCount) members")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 4) {
                            Circle()
                                .fill(room.currentStatus == .base ? Color.green : Color.orange)
                                .frame(width: 6, height: 6)
                            
                            Text(room.currentStatus.rawValue.capitalized)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                // 참여 가능 여부에 따른 아이콘
                if room.currentMemberCount < room.maximumMemberCount {
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
        .disabled(room.currentMemberCount >= room.maximumMemberCount)
        .opacity(room.currentMemberCount >= room.maximumMemberCount ? 0.6 : 1.0)
    }
}
