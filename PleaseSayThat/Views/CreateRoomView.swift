//
//  CreateRoomView.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//

import SwiftUI

// 방 생성 화면 뷰
struct CreateRoomView: View {
    var viewModel: ContentViewModel
    @State private var roomName: String = ""
    @State private var maxMembers: Int = 10
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
                
                Text("Create New Room")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                // 균형을 위한 빈 뷰
                Image(systemName: "arrow.left")
                    .font(.title3)
                    .foregroundColor(.clear)
            }
            .padding(.horizontal)
            
            // 방 구성 양식
            Form {
                Section {
                    TextField("Room Name", text: $roomName)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    Stepper("Maximum Members: \(maxMembers)", value: $maxMembers, in: 2...20)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }
            .frame(maxHeight: 200)
            
            Spacer()
            
            // 방 생성 버튼
            Button(action: {
                createRoom()
            }) {
                Text("Create Room")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 280, height: 60)
                    .background(Color.blue)
                    .cornerRadius(15)
            }
            .disabled(roomName.isEmpty)
            .opacity(roomName.isEmpty ? 0.6 : 1.0)
            .padding(.bottom, 30)
        }
        .padding()
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    private func createRoom() {
        if viewModel.createRoom(name: roomName, maxMembers: maxMembers) {
            // 성공적으로 생성되면 방 상세 화면으로 자동 이동 (이미 ViewModel에서 처리됨)
        } else {
            // 실패시 알림
            alertMessage = "Unable to create room. Please try again."
            showingAlert = true
        }
    }
}
