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
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                                
                Spacer()
                
                Text("인원 : \(room.currentMemberCount)/\(room.maximumMemberCount)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 20)
                
                Divider()

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
            .padding(6)
            .overlay(
            RoundedRectangle(cornerRadius: 8)
                .inset(by: 1)
                .stroke(Color(red: 0.63, green: 0.63, blue: 0.63), lineWidth: 1)
            )
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(room.currentMemberCount >= room.maximumMemberCount)
        .opacity(room.currentMemberCount >= room.maximumMemberCount ? 0.6 : 1.0)
    }
}
