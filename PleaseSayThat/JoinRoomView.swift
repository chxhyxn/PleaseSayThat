//
//  JoinRoomView.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//

import SwiftUI

// 방 참여 화면 뷰
struct JoinRoomView: View {
    var viewModel: ContentViewModel
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    // Sample available rooms - in a real app, this would come from your backend or a service
    @State private var availableRooms: [AvailableRoom] = [
        AvailableRoom(id: UUID(), name: "General Chat", memberCount: 8, maxMembers: 10),
        AvailableRoom(id: UUID(), name: "Game Night", memberCount: 4, maxMembers: 12),
        AvailableRoom(id: UUID(), name: "Study Group", memberCount: 3, maxMembers: 8),
        AvailableRoom(id: UUID(), name: "Coffee Break", memberCount: 5, maxMembers: 6),
        AvailableRoom(id: UUID(), name: "Movie Discussions", memberCount: 7, maxMembers: 15),
        AvailableRoom(id: UUID(), name: "Book Club", memberCount: 6, maxMembers: 10)
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // 헤더
            HStack {
                Button(action: {
                    viewModel.navigateToMain()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Text("Join Room")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                // 균형을 위한 빈 뷰
                Image(systemName: "arrow.left")
                    .font(.title3)
                    .foregroundColor(.clear)
            }
            .padding(.horizontal)
            
            // 사용 가능한 방 목록 섹션
            VStack(alignment: .leading) {
                Text("Available Rooms")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(availableRooms) { room in
                            RoomListItemView(room: room) {
                                // 방 선택 시 처리
                                viewModel.joinRoom(with: room.id.uuidString)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding()
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}

// 사용 가능한 방 모델
struct AvailableRoom: Identifiable {
    let id: UUID
    let name: String
    let memberCount: Int
    let maxMembers: Int
}

