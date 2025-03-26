import SwiftUI

// 방 생성 화면 뷰
struct CreateRoomView: View {
    var viewModel: ContentViewModel
    @State private var roomName: String = ""
    @State private var maxMembers: Int = 6
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 10) {
            // 헤더
            HStack{
                Button(action: {
                    viewModel.navigateToMain()
                }) {
                    HStack(spacing: 2) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        
                        Text("이전으로")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                            .padding()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48, alignment: .leading)
                }
                .buttonStyle(.plain)

                Spacer()
            }
            
            VStack(spacing: 12) {
                HStack {
                    Text("팀명")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                    Spacer()
                }
                
                TextField("팀명을 입력해주세요", text: $roomName)
                    .textFieldStyle(PlainTextFieldStyle()) // 기본 스타일 제거
                    .padding(16)
                    .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48, alignment: .leading)
                    .background(.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                        .inset(by: -0.5)
                        .stroke(.gray, lineWidth: 1)
                    )
                
                Spacer()
                    .frame(height: 12)
                
                HStack {
                    Text("인원 수 설정")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                    Spacer()
                }
                
                HStack(spacing: 8) {
                    Button(action: {
                        if maxMembers > 2 {
                            maxMembers -= 1
                        }
                    }) {
                        Image(systemName: "minus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .padding(16)
                            .background(.lightGray)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    
                    Text("\(maxMembers)")
                        .font(.system(size: 16))
                        .padding(16)
                        .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48, alignment: .center)
                        .background(.white)
                        .cornerRadius(8)
                    
                    Button(action: {
                        if maxMembers < 10 {
                            maxMembers += 1
                        }
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .padding(16)
                            .background(.lightGray)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
                
                Spacer()
                    .frame(height: 12)
                
                Button {
                    createRoom()
                } label: {
                    Text("팀 생성")
                        .font(.system(size: 15))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48, alignment: .center)
                        .foregroundStyle(.white)
                        .background(.accent)
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
                .disabled(roomName.isEmpty)
                .opacity(roomName.isEmpty ? 0.7 : 1.0)
            }
            .frame(maxWidth: 368, maxHeight: 272)
            
            Spacer()
            
        }
        .padding()
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    private func createRoom() {
        guard let currentUser = UserManager.shared.currentUser else { return }
        
        // RoomManager를 통해 Firestore에 방 생성 요청 (비동기)
        RoomManager.shared.createRoom(
            name: roomName,
            ownerId: currentUser.id,
            maximumMemberCount: maxMembers
        ) { result in
            switch result {
            case .success(let room):
                // 성공 시: 뷰 이동/로직 등 처리
                viewModel.navigateToRoomDetail(roomId: room.id)
                RoomManager.shared.addUserToRoom(roomId: room.id, userId: currentUser.id, completion: {_ in print("1")})
                UserManager.shared.addParticipatingRoom(roomId: room.id)
                UserManager.shared.updateLastAccessedRoom(roomId: room.id)
                RoomManager.shared.refreshListening()
                
            case .failure(let error):
                // 실패 시: alert 표시
                alertMessage = "Unable to create room. \(error.localizedDescription)"
                showingAlert = true
            }
        }
    }
}

