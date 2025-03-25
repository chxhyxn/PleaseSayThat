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
    @State private var roomStatus: RoomStatus = .open
    @State private var showStatusChangeAlert = false
    @State private var selectedStatus: RoomStatus = .open
    
    // Status button configuration
    private let statusButtons: [[StatusButtonConfig]] = [
        [
            StatusButtonConfig(status: .open, icon: "door.left.hand.open", color: .green),
            StatusButtonConfig(status: .inProgress, icon: "person.3.sequence.fill", color: .blue),
            StatusButtonConfig(status: .pending, icon: "clock", color: .yellow)
        ],
        [
            StatusButtonConfig(status: .closed, icon: "lock.fill", color: .red),
            StatusButtonConfig(status: .archived, icon: "archivebox.fill", color: .gray),
            StatusButtonConfig(status: .pending, icon: "ellipsis", color: .purple)
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
                    
                    Text(roomName)
                        .font(.headline)
                    
                    Spacer()
                    
                    Menu {
                        Button(action: {
                            // 방 정보 보기
                        }) {
                            Label("Room Info", systemImage: "info.circle")
                        }
                        
                        Button(action: {
                            // 참가자 목록 보기
                        }) {
                            Label("Members (\(memberCount)/\(maxMembers))", systemImage: "person.3")
                        }
                        
                        Button(action: {
                            // 방 나가기
                            viewModel.navigateToMain()
                        }) {
                            Label("Leave Room", systemImage: "rectangle.portrait.and.arrow.right")
                        }
                        
                        if isOwner {
                            Divider()
                            
                            Button(action: {
                                // 방 설정 변경
                            }) {
                                Label("Room Settings", systemImage: "gearshape")
                            }
                            
                            Button(action: {
                                // 방 삭제
                            }) {
                                Label("Delete Room", systemImage: "trash")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // 방 상태 표시
                HStack {
                    Circle()
                        .fill(roomStatus == .open ? Color.green : Color.orange)
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
    }
}
