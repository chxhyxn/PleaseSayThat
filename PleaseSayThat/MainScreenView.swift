//
//  MainScreenView.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/25/25.
//

import SwiftUI

// 메인 화면 뷰
struct MainScreenView: View {
    var viewModel: ContentViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            // 앱 로고 또는 제목
            Image(systemName: "person.3.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Room Chat")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
                .frame(height: 50)
            
            // 방 생성 버튼
            Button(action: {
                viewModel.navigateToCreateRoom()
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Create Room")
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 280, height: 60)
                .background(Color.blue)
                .cornerRadius(15)
            }
            
            // 방 참여 버튼
            Button(action: {
                viewModel.navigateToJoinRoom()
            }) {
                HStack {
                    Image(systemName: "person.badge.plus.fill")
                    Text("Join Room")
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 280, height: 60)
                .background(Color.green)
                .cornerRadius(15)
            }
            
            Spacer()
        }
        .padding()
    }
}
