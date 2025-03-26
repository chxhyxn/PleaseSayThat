import SwiftUI
import Firebase
import FirebaseFirestore

struct PopOverView: View {
    @State private var roomName: String = "No Room"
    @State private var currentStatus: RoomStatus = .base
    @State private var isListening: Bool = false
    @State private var listenerRegistration: ListenerRegistration?
    
    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Image(systemName: "person.3.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.blue)
                
                Text("Room Status")
                    .font(.headline)
            }
            .padding(.top, 8)
            
            Divider()
            
            // Room info
            VStack(spacing: 10) {
                Text(roomName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                HStack {
                    Circle()
                        .fill(statusColor(for: currentStatus))
                        .frame(width: 8, height: 8)
                    
                    Text(currentStatus.rawValue.capitalized)
                        .font(.system(size: 14))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(statusColor(for: currentStatus).opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding(12)
        .frame(width: 240, height: 180)
        .onAppear {
            startListening()
        }
        .onDisappear {
            stopListening()
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
    
    // Start listening for room status changes
    private func startListening() {
        guard !isListening,
              let currentUser = UserManager.shared.currentUser,
              let roomId = currentUser.currentRoomId else {
            roomName = "No Active Room"
            return
        }
        
        isListening = true
        let db = Firestore.firestore()
        let roomRef = db.collection("rooms").document(roomId.uuidString)
        
        // Set up real-time listener
        listenerRegistration = roomRef.addSnapshotListener { snapshot, error in
            guard let document = snapshot, document.exists,
                  let data = document.data() else {
                roomName = "Room Not Found"
                return
            }
            
            // Get room name
            if let name = data["name"] as? String {
                roomName = name
            }
            
            // Get current status
            if let statusString = data["currentStatus"] as? String,
               let status = RoomStatus(rawValue: statusString) {
                currentStatus = status
            } else {
                currentStatus = .base
            }
        }
    }
    
    // Stop listening when view disappears
    private func stopListening() {
        listenerRegistration?.remove()
        isListening = false
    }
}
