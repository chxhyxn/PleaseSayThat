//
//  RoomDetailView.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//

import SwiftUI

// 방 상세 화면 뷰 (구현 예시)
struct RoomDetailView: View {
    var viewModel: ContentViewModel
    var roomId: UUID
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.navigateToMain()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Text("Room \(roomId.uuidString.prefix(8))")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    // 추가 액션 (예: 설정)
                }) {
                    Image(systemName: "gear")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            Spacer()
            
            // 방 콘텐츠 구현 부분
            Text("Room Detail View")
                .font(.title)
            
            Text("This is where the room content would go")
                .padding()
            
            Spacer()
        }
    }
}
