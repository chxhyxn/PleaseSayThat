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
    @State private var roomCode: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 25) {
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
            
            Spacer()
                .frame(height: 50)
                
            // 방 코드 입력
            VStack(alignment: .leading, spacing: 10) {
                Text("Enter Room Code")
                    .font(.headline)
                
                TextField("Room Code", text: $roomCode)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            Spacer()
            
            // 방 참여 버튼
            Button(action: {
                joinRoom()
            }) {
                Text("Join Room")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 280, height: 60)
                    .background(Color.green)
                    .cornerRadius(15)
            }
            .disabled(roomCode.isEmpty)
            .opacity(roomCode.isEmpty ? 0.6 : 1.0)
            .padding(.bottom, 30)
        }
        .padding()
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    private func joinRoom() {
        if viewModel.joinRoom(with: roomCode) {
            // 성공적으로 참여하면 방 상세 화면으로 자동 이동 (이미 ViewModel에서 처리됨)
        } else {
            // 실패시 알림
            alertMessage = "Invalid room code. Please try again."
            showingAlert = true
        }
    }
}
