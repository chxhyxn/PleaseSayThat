import SwiftUI

struct ContentView: View {
    @State private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.currentScreen {
            case .main:
                MainScreenView(viewModel: viewModel)
            case .createRoom:
                CreateRoomView(viewModel: viewModel)
            case .joinRoom:
                JoinRoomView(viewModel: viewModel)
            case .roomDetail(let roomId):
                RoomDetailView(viewModel: viewModel, roomId: roomId)
            }
        }
    }
}




