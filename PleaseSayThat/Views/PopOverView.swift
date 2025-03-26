import SwiftUI
import Firebase
import FirebaseFirestore

struct PopOverView: View {
    @State private var isListening: Bool = false
    @State private var listenerRegistration: ListenerRegistration?
    
    @ObservedObject private var roomManager = RoomManager.shared
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(roomManager.roomName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Circle()
                    .fill(statusColor(for: roomManager.currentStatus))
                    .frame(width: 8, height: 8)
                
                Text(roomManager.currentStatus.rawValue.capitalized)
                    .font(.system(size: 14))
                
                Button(action: {
                    print(roomManager.roomName)
                    print(roomManager.currentStatus.rawValue.capitalized)
                }) {
                    Text("엥엥 ")
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .cornerRadius(12)
        }
        .frame(width: 240, height: 180)
        .onAppear {
            roomManager.startListening()
        }
        .onDisappear {
            roomManager.stopListening()
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
