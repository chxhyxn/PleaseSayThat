import SwiftUI
import Firebase
import FirebaseFirestore

struct PopOverView: View {
    @State private var isListening: Bool = false
    @State private var listenerRegistration: ListenerRegistration?
    
    @ObservedObject private var roomManager = RoomManager.shared
    
    var body: some View {
        VStack(spacing: 12) {
            if let currentUser = UserManager.shared.currentUser {
                if currentUser.currentRoomId == nil{
                    Text("참가중인 방이 없습니다.")
                        .padding()
                }else {
                    HStack {
                        Text(roomManager.roomName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Circle()
                            .fill(statusColor(for: roomManager.currentStatus))
                            .frame(width: 8, height: 8)
                        
                        Text(roomManager.currentStatus.rawValue.capitalized)
                            .font(.system(size: 14))
                    }
                    .frame(width: 240, height: 180)
                    .onAppear {
                        roomManager.startListening()
                    }
                    .onDisappear {
                        roomManager.stopListening()
                    }
                }
            }
        }
    }
    
    // Get color for each status
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
