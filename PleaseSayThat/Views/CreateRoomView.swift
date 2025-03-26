import SwiftUI

// 방 생성 화면 뷰
struct CreateRoomView: View {
    var viewModel: ContentViewModel
    @State private var roomName: String = ""
    @State private var maxMembers: Int = 6
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            // 헤더
            HStack {
                Button(action: {
                    viewModel.navigateToMain()
                }) {
                    Text("← 이전으로")
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                        .padding()
                }
                .buttonStyle(.plain)

                Spacer()
            }
            
            VStack {
                HStack {
                    Text("미팅룸 이름")
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                    Spacer()
                }
                
                TextField("방 이름을 입력하세요", text: $roomName)
                    .textFieldStyle(PlainTextFieldStyle()) // 기본 스타일 제거
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white)
                    )
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(Color.gray, lineWidth: 1)
                    })
                    .padding(.horizontal)
                
                HStack {
                    Text("인원 수 설정")
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                    Spacer()
                }
                
                HStack(spacing: 0) {
                    Button(action: {
                        if maxMembers > 2 {
                            maxMembers -= 1
                        }
                    }) {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 20))
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .background(Color(red: 0.4784, green: 0.5451, blue: 0.2314))
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                    
                    Text("\(maxMembers)")
                        .background(
                            RoundedRectangle(cornerRadius: 0)
                                .fill(.white)
                        )
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 0)
                                .strokeBorder(Color.gray, lineWidth: 1)
                        })
                    
                    Button(action: {
                        if maxMembers < 10 {
                            maxMembers += 1
                        }
                    }) {
                        Image(systemName: "chevron.up")
                            .font(.system(size: 20))
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .background(Color(red: 0.4784, green: 0.5451, blue: 0.2314))
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }
                
                
                Button {
                    createRoom()
                } label: {
                    Text("미팅룸 생성")
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                        .background(.accent)
                }
                .cornerRadius(10)
                .buttonStyle(.plain)
                .disabled(roomName.isEmpty)
                .opacity(roomName.isEmpty ? 0.8 : 1.0)
            }
            
            Spacer()
            
        }
        .padding()
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    private func createRoom() {
        // 실제로는 로그인 정보 등에서 유저 UUID를 받아와야 합니다.
        // 여기서는 간단히 new UUID를 예시로 사용합니다.
        let ownerId = UUID()
        
        // RoomManager를 통해 Firestore에 방 생성 요청 (비동기)
        RoomManager.shared.createRoom(
            name: roomName,
            ownerId: ownerId,
            maximumMemberCount: maxMembers
        ) { result in
            switch result {
            case .success(let room):
                // 성공 시: 뷰 이동/로직 등 처리
                viewModel.navigateToRoomDetail(roomId: room.id)
                
            case .failure(let error):
                // 실패 시: alert 표시
                alertMessage = "Unable to create room. \(error.localizedDescription)"
                showingAlert = true
            }
        }
    }
}

