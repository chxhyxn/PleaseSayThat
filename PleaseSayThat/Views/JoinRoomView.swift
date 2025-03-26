import SwiftUI
import FirebaseFirestore

// 방 참여 화면 뷰
struct JoinRoomView: View {
    var viewModel: ContentViewModel
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    // Rooms from Firestore
    @State private var rooms: [Room] = []
    
    var body: some View {
        VStack {
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
                
                Button(action: {
                    fetchRooms()
                }) {
                    HStack(spacing: 2) {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 48, alignment: .leading)
                }
                .buttonStyle(.plain)
            }
            
            // 사용 가능한 방 목록 섹션
            VStack {
                if isLoading {
                    HStack {
                        VStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(1.5)
                            Text("Loading rooms...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.top, 8)
                            Spacer()
                        }
                    }
                } else if rooms.isEmpty {
                    HStack {
                        VStack {
                            Spacer()
                            Image(systemName: "tray")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("No rooms available")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                            Text("Create a room or refresh to check again")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.top, 4)
                            Spacer()
                        }
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(rooms) { room in
                                RoomListItemView(room: room) {
                                    joinRoom(room: room)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .padding(24)
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
        .onAppear {
            fetchRooms()
        }
    }
    
    // Firestore에서 방 목록 가져오기
    private func fetchRooms() {
        isLoading = true
        rooms = []
        
        let db = Firestore.firestore()
        db.collection("rooms").getDocuments { snapshot, error in
            isLoading = false
            
            if let error = error {
                alertMessage = "Failed to fetch rooms: \(error.localizedDescription)"
                showingAlert = true
                return
            }
            
            guard let documents = snapshot?.documents else {
                return
            }
            
            for document in documents {
                let data = document.data()
                
                // 필수 필드 추출
                guard let name = data["name"] as? String,
                      let ownerIdString = data["ownerId"] as? String,
                      let currentMemberCount = data["currentMemberCount"] as? Int,
                      let maximumMemberCount = data["maximumMemberCount"] as? Int else {
                    continue
                }
                
                // UUID 변환
                guard let ownerId = UUID(uuidString: ownerIdString),
                      let roomId = UUID(uuidString: document.documentID) else {
                    continue
                }
                
                // 현재 상태 (기본값 설정)
                let currentStatusString = data["currentStatus"] as? String ?? "base"
                let currentStatus = RoomStatus(rawValue: currentStatusString) ?? .base
                
                // 현재 멤버 IDs (선택 사항)
                var currentMemberIds: [UUID] = []
                if let memberIdStrings = data["currentMemberIds"] as? [String] {
                    currentMemberIds = memberIdStrings.compactMap { UUID(uuidString: $0) }
                }
                
                // FirestoreRoom 객체 생성 및 추가
                let room = Room(
                    id: roomId,
                    name: name,
                    ownerId: ownerId,
                    currentMemberCount: currentMemberCount,
                    maximumMemberCount: maximumMemberCount,
                    currentMemberIds: currentMemberIds,
                    currentStatus: currentStatus
                )
                
                rooms.append(room)
            }
            
            // 방 이름 순으로 정렬
            rooms.sort { $0.name < $1.name }
        }
    }
    
    // 방 참여 처리
    private func joinRoom(room: Room) {
        viewModel.navigateToRoomDetail(roomId: room.id)
        if let currentUser = UserManager.shared.currentUser{
            RoomManager.shared.addUserToRoom(roomId: room.id, userId: currentUser.id, completion: {_ in print("1")})
        }
        UserManager.shared.addParticipatingRoom(roomId: room.id)
        UserManager.shared.updateLastAccessedRoom(roomId: room.id)
        RoomManager.shared.refreshListening()
    }
}
