//
//  RoomDetailView.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//

import SwiftUI

// 방 상세 화면 뷰
struct RoomDetailView: View {
    var viewModel: ContentViewModel
    var roomId: UUID
    
    // 실제 구현에서는 이 값들을 Room 엔티티에서 가져옵니다
    @State private var roomName: String = "Sample Room"
    @State private var memberCount: Int = 5
    @State private var maxMembers: Int = 10
    @State private var isOwner: Bool = true
    @State private var roomStatus: RoomStatus = .base
    @State private var selectedStatus: RoomStatus = .base
    @State private var participatingRooms: [UUID: String] = [:] // 참여 중인 방 ID와 이름
    @State private var showRoomDropdown: Bool = false
    
    // Status button configuration
    private let statusButtons: [[StatusButtonConfig]] = [
        [
            StatusButtonConfig(status: .niceTry, icon: "door.left.hand.open", color: .green),
            StatusButtonConfig(status: .clap, icon: "person.3.sequence.fill", color: .blue),
            StatusButtonConfig(status: .breakTime, icon: "clock", color: .yellow)
        ],
        [
            StatusButtonConfig(status: .otherOpinion, icon: "lock.fill", color: .red),
            StatusButtonConfig(status: .organize, icon: "archivebox.fill", color: .gray),
            StatusButtonConfig(status: .mountain, icon: "ellipsis", color: .purple)
        ]
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // 헤더
            VStack(spacing: 5) {
                HStack {
                    Button(action: {
                        viewModel.navigateToMain()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    // Room dropdown menu
                    Menu {
                        ForEach(Array(participatingRooms.keys), id: \.self) { roomId in
                            Button(action: {
                                viewModel.navigateToRoomDetail(roomId: roomId)
                            }) {
                                HStack {
                                    Text(participatingRooms[roomId] ?? "Unknown Room")
                                    if roomId == self.roomId {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text(roomName)
                                .font(.headline)
                            Image(systemName: "chevron.down")
                                .font(.caption)
                        }
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                    }
                    
                    Spacer()
                    
                    
                    // 방 상태 표시
                    HStack {
                        Circle()
                            .fill(roomStatus == .base ? Color.green : Color.orange)
                            .frame(width: 8, height: 8)
                        
                        Text(roomStatus.rawValue.capitalized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("•")
                            .foregroundColor(.secondary)
                        
                        Text("\(memberCount) members")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 10)
                }
            }
            
            // 2행 3열의 버튼들 (방 상태 변경)
            if isOwner {
                VStack(spacing: 20) {
                    Text("Change Room Status")
                        .font(.headline)
                        .padding(.top, 20)
                    
                    ForEach(0..<2, id: \.self) { row in
                        HStack(spacing: 15) {
                            ForEach(0..<3, id: \.self) { col in
                                let config = statusButtons[row][col]
                                StatusButton(
                                    icon: config.icon,
                                    title: config.status.rawValue.capitalized,
                                    color: config.color,
                                    isSelected: roomStatus == config.status
                                ) {
                                    selectedStatus = config.status
                                    roomStatus = selectedStatus
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
        }
        .onAppear {
            loadRoomData()
            fetchParticipatingRooms()
        }
    }
    
    // 방 데이터 로드 (실제 구현에서는 서버 또는 로컬 DB에서 가져옵니다)
    private func loadRoomData() {
        // 여기서는 간단히 샘플 데이터로 설정합니다
        // 실제 구현에서는 API 호출 또는 로컬 스토리지에서 방 정보를 가져와야 합니다
        roomName = "Room #\(roomId.uuidString.prefix(6))"
        
        // 현재 사용자가 방 소유자인지 확인
        if let currentUser = UserManager.shared.currentUser {
            isOwner = currentUser.ownedRoomIds.contains(roomId)
        }
    }
    
    // 사용자가 참여 중인 방 목록 가져오기
    private func fetchParticipatingRooms() {
        guard let currentUser = UserManager.shared.currentUser else { return }
        
        // 실제 구현에서는 서버에서 방 정보를 가져와야 합니다
        // 여기서는 간단히 참여 중인 방 ID 목록만 사용합니다
        var rooms: [UUID: String] = [:]
        
        for roomId in currentUser.participatingRoomIds {
            // 실제 구현에서는 각 방의 이름을 서버에서 가져와야 합니다
            rooms[roomId] = "Room #\(roomId.uuidString.prefix(6))"
        }
        
        // 샘플 데이터가 없을 경우 몇 개 추가
        if rooms.isEmpty {
            let sampleRoomIds = [
                UUID(), UUID(), UUID(), self.roomId
            ]
            
            for (index, id) in sampleRoomIds.enumerated() {
                rooms[id] = "Sample Room \(index + 1)"
            }
        }
        
        // 현재 방이 목록에 없으면 추가
        if !rooms.keys.contains(self.roomId) {
            rooms[self.roomId] = roomName
        }
        
        self.participatingRooms = rooms
    }
}
