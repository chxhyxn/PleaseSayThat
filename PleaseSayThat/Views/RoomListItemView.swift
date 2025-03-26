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
                Text(room.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("\(room.currentMemberCount)/\(room.maximumMemberCount) members")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // 참여 가능 여부에 따른 아이콘
                if room.currentMemberCount < room.maximumMemberCount {
                    HStack(spacing: 8) {
                        Text("참여")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Image(systemName: "arrow.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.accent)
                    .cornerRadius(8)
                } else {
                    HStack(spacing: 8) {
                        Text("인원 마감")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.lightGray)
                    .cornerRadius(8)
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
