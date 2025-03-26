import SwiftUI
import Firebase
import FirebaseFirestore

struct PopOverView: View {
    @State private var isListening: Bool = false
    @State private var listenerRegistration: ListenerRegistration?
    @State private var showStatus: Bool = false
    @State private var lastStatus: RoomStatus = .base
    @State private var timer: Timer? = nil
    @State private var scale: CGFloat = 0.8
    
    // Duration in seconds to show the status
    private let statusDisplayDuration: Double = 5.0
    // Animation duration
    private let animationDuration: Double = 0.5
    
    @ObservedObject private var roomManager = RoomManager.shared
    
    var body: some View {
        VStack {
            if let currentUser = UserManager.shared.currentUser {
                if currentUser.currentRoomId == nil {
                    Text("참가중인 방이 없습니다.")
                        .padding()
                        .frame(width: 240)
                } else {
                    VStack {
                        Image(roomManager.currentStatus.rawValue)
                            .resizable()
                            .scaledToFill()
                            .frame(width: !showStatus || roomManager.currentStatus == .base ? 1 : 240,
                                   height: !showStatus || roomManager.currentStatus == .base ? 1 : 180)
                            .scaleEffect(scale)
                            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: scale)
                    }
                    .onAppear {
                        roomManager.startListening()
                    }
                    .onDisappear {
                        roomManager.stopListening()
                        timer?.invalidate()
                        timer = nil
                    }
                    .onChange(of: roomManager.currentStatus) { _, newStatus in
                        handleStatusChange(newStatus)
                    }
                }
            }
        }
    }
    
    private func handleStatusChange(_ newStatus: RoomStatus) {
        // If we're changing from base status to something else,
        // or changing between non-base statuses
        if newStatus != .base || (lastStatus != .base && newStatus != lastStatus) {
            // Prepare animation values
            scale = 0.8
            
            // Show the status
            showStatus = true
            
            // Animate in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                scale = 1.0
            }
            
            // Invalidate existing timer if there is one
            timer?.invalidate()
            
            // Start a new timer
            timer = Timer.scheduledTimer(withTimeInterval: statusDisplayDuration, repeats: false) { _ in
                // Animate out
                withAnimation(.easeOut(duration: animationDuration)) {
                    scale = 1.2
                }
                
                // Delay hiding until animation completes
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                    showStatus = false
                    scale = 0.8
                }
            }
        }
        
        // Update last status
        lastStatus = newStatus
    }
}
