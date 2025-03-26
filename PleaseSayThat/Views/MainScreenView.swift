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
        ZStack {
            Image("bg1")
                .resizable()
                .scaledToFill()
            
            VStack(spacing: 15) {
                Text("Welcome to \n Meeting Picket!")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(.accent)
                
                Text("지금, 당신의 마음을 전해보세요!")
                    .font(.system(size: 16))
                    .padding(.bottom, 30)
                    .foregroundColor(.black)
                
                HStack {
                    // 방 생성 버튼
                    Button(action: {
                        viewModel.navigateToCreateRoom()
                    }) {
                        Text("방 만들기")
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .frame(width: 133, height: 48, alignment: .center)
                            .background(.accent)
                            .foregroundStyle(.white)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    
                    // 방 참여 버튼
                    Button(action: {
                        viewModel.navigateToJoinRoom()
                    }) {
                        Text("참여하기")
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .frame(width: 133, height: 48, alignment: .center)
                            .background(.white)
                            .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .inset(by: 1)
                                .stroke(Color(red: 0.63, green: 0.63, blue: 0.63), lineWidth: 2)
                            )
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
