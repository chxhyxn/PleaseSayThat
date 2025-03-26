import SwiftUI
import Firebase
import FirebaseFirestore

struct PopOverView: View {
    @State private var isListening: Bool = false
    @State private var listenerRegistration: ListenerRegistration?
    
    @ObservedObject private var roomManager = RoomManager.shared
    
    var body: some View {
        VStack {
            if let currentUser = UserManager.shared.currentUser {
                if currentUser.currentRoomId == nil{
                    Text("참가중인 방이 없습니다.")
                        .padding()
                }else {
                    VStack {
                        if roomManager.currentStatus == .base {
                            Text("듣고싶은 말을 팀에게 공유해보세요.")
                                .padding()
                        }else {
                            Image(roomManager.currentStatus.rawValue)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 240, height: 180)
                        }
                    }
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
}
