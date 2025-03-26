import SwiftUI
import FirebaseFirestore

// 방 상세 화면 뷰
struct RoomDetailView: View {
    var viewModel: ContentViewModel
    var roomId: UUID
    
    @State private var roomName: String = ""
    @State private var memberCount: Int = 0
    @State private var maxMembers: Int = 0
    @State private var isOwner: Bool = false
    @State private var roomStatus: RoomStatus = .base
    @State private var selectedStatus: RoomStatus = .base
    @State private var participatingRooms: [UUID: String] = [:]
    @State private var isUpdatingStatus: Bool = false
    @State private var listenerRegistration: ListenerRegistration?
    @State private var isLoading: Bool = true
    
    // Status button configuration
    private let statusButtons: [[StatusButtonConfig]] = [
        [
            StatusButtonConfig(status: .niceTry, image: "niceTry", color: .green),
            StatusButtonConfig(status: .clap, image: "clap", color: .blue),
            StatusButtonConfig(status: .breakTime, image: "breakTime", color: .yellow)
        ],
        [
            StatusButtonConfig(status: .otherOpinion, image: "otherOpinion", color: .red),
            StatusButtonConfig(status: .organize, image: "organize", color: .gray),
            StatusButtonConfig(status: .mountain, image: "mountain", color: .purple)
        ]
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            if isLoading {
                Spacer()
                ProgressView("Loading room details...")
                Spacer()
            } else {
                // 헤더
                VStack(spacing: 24) {
                    HStack {
                        Button(action: {
                            viewModel.navigateToJoinRoom()
                            UserManager.shared.updateLastAccessedRoom(roomId: nil)
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
                            Text("\(memberCount) members")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Button(action: {
                                exitRoom()
                            }) {
                                Text("Exit Room")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(4)
                            }
                        }
                        .padding(.bottom, 10)
                    }
                }
                
                VStack(spacing: 16) {
                    ForEach(0..<2, id: \.self) { row in
                        HStack(spacing: 16) {
                            ForEach(0..<3, id: \.self) { col in
                                let config = statusButtons[row][col]
                                StatusButton(
                                    image: config.image,
                                    title: config.status.rawValue.capitalized,
                                    color: config.color,
                                    isSelected: roomStatus == config.status
                                ) {
                                    selectedStatus = config.status
                                    changeRoomStatus()
                                }
                            }
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
        }
        .onAppear {
            setupRoomListener()
            fetchParticipatingRooms()
        }
        .onDisappear {
            removeRoomListener()
        }
    }
    
    // 방 상태 변경 함수
    private func changeRoomStatus() {
        guard !isUpdatingStatus else { return }
        isUpdatingStatus = true
        
        RoomManager.shared.changeRoomStatus(
            currentRoomId: roomId,
            selectedStatus: selectedStatus
        ) { result in
            DispatchQueue.main.async {
                isUpdatingStatus = false
                
                switch result {
                case .success:
                    // 상태 업데이트 성공 - Firestore 리스너가 UI를 자동으로 업데이트할 것임
                    print("Successfully updated room status to \(selectedStatus.rawValue)")
                case .failure(let error):
                    print("Failed to update room status: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Firestore 실시간 리스너 설정
    private func setupRoomListener() {
        isLoading = true
        
        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId.uuidString)
        
        // 리스너 설정
        listenerRegistration = roomRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching room: \(error?.localizedDescription ?? "Unknown error")")
                isLoading = false
                return
            }
            
            guard document.exists else {
                print("Room document does not exist")
                isLoading = false
                return
            }
            
            guard let data = document.data() else {
                print("Room document is empty")
                isLoading = false
                return
            }
            
            DispatchQueue.main.async {
                // 방 데이터 파싱
                if let name = data["name"] as? String {
                    self.roomName = name
                }
                
                if let statusString = data["currentStatus"] as? String,
                   let status = RoomStatus(rawValue: statusString) {
                    self.roomStatus = status
                    // 선택된 상태도 동일하게 설정 (UI에 반영)
                    self.selectedStatus = status
                }
                
                if let memberCount = data["currentMemberCount"] as? Int {
                    self.memberCount = memberCount
                }
                
                if let maxMembers = data["maximumMemberCount"] as? Int {
                    self.maxMembers = maxMembers
                }
                
                // 소유자 확인
                if let ownerIdString = data["ownerId"] as? String,
                   let currentUser = UserManager.shared.currentUser {
                    self.isOwner = (ownerIdString == currentUser.id.uuidString)
                }
                
                self.isLoading = false
            }
        }
    }
    
    // Firestore 리스너 해제
    private func removeRoomListener() {
        listenerRegistration?.remove()
    }
    
    // 사용자가 참여 중인 방 목록 가져오기
    private func fetchParticipatingRooms() {
        guard let currentUser = UserManager.shared.currentUser else {
            return
        }
        
        var rooms: [UUID: String] = [:]
        let db = Firestore.firestore()
        
        // 먼저 현재 방 추가
        rooms[self.roomId] = "Loading..." // 임시 이름, 나중에 업데이트될 것
        
        // 사용자가 참여 중인 다른 방 정보 가져오기
        for roomId in currentUser.participatingRoomIds {
            // Firestore에서 방 정보 가져오기
            db.collection("rooms").document(roomId.uuidString).getDocument { snapshot, error in
                if let error = error {
                    print("Error fetching room \(roomId): \(error.localizedDescription)")
                    return
                }
                
                if let document = snapshot, document.exists, let data = document.data() {
                    if let name = data["name"] as? String {
                        DispatchQueue.main.async {
                            // 방 이름 업데이트
                            self.participatingRooms[roomId] = name
                        }
                    }
                }
            }
        }
        
        self.participatingRooms = rooms
    }
    
    private func exitRoom() {
        if let currentUser = UserManager.shared.currentUser {
            RoomManager.shared.removeUserFromRoom(roomId: roomId, userId: currentUser.id) { result in
                switch result {
                case .success:
                    UserManager.shared.removeParticipatingRoom(roomId: roomId)
                    
                    viewModel.navigateToJoinRoom()
                    UserManager.shared.updateLastAccessedRoom(roomId: nil)
                    print("방 나가기에 성공했습니다!")
                    
                case .failure(let error):
                    viewModel.navigateToJoinRoom()
                    print("방 나가기에 실패했습니다: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // 상태에 따른 색상 반환
    private func statusColor(for status: RoomStatus) -> Color {
        switch status {
        case .base:
            return .green
        case .niceTry:
            return .green
        case .clap:
            return .blue
        case .breakTime:
            return .yellow
        case .otherOpinion:
            return .red
        case .organize:
            return .gray
        case .mountain:
            return .purple
        }
    }
}
