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
        HStack {
            Image("tree1")
            
            VStack {
                Text("Welcome to \n Meeting Picket!")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 40, weight: .semibold, design: .default))
                    .foregroundColor(.accent)
                    .padding(.horizontal, 10)
                    .padding(10)
                
                Text("지금, 당신의 마음을 전해보세요!")
                    .font(.system(size: 15))
                    .padding(.bottom, 40)
                    .foregroundColor(.black)
                
                HStack {
                    // 방 생성 버튼
                    Button(action: {
                        viewModel.navigateToCreateRoom()
                    }) {
                        Text("방 만들기")
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .padding(.vertical, 13)
                            .padding(.horizontal, 40)
                            .foregroundColor(.white)
                            .background(.accent)
                    }
                    .cornerRadius(10)
                    .buttonStyle(.plain)
                    
                    // 방 참여 버튼
                    Button(action: {
                        viewModel.navigateToJoinRoom()
                    }) {
                        Text("참여하기")
                            .font(.system(size: 15))
                            .padding(.vertical, 13)
                            .padding(.horizontal,40)
                            .foregroundColor(.black)
                            .background(Color.white)
                    }
                    .cornerRadius(10)
                    .buttonStyle(.plain)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.gray.opacity(0.8)), lineWidth: 2))
                }
            }
            
            Image("tree1")
        }
    }
}
