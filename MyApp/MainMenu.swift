//
//  MainMenu.swift
//  MyApp
//
//  Created by nv01 on 2026/07/27.
//

import SwiftUI

struct MainMenu: View {
    @State private var isPresentedSelect: Bool = false    //画面遷移の時に使用するbool値
    @State private var isPresentedRecord: Bool = false
    let radius = CGFloat(10)
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color.yellow)
                .ignoresSafeArea()
            
            VStack{
                Text("game")
                    .frame(width: 200, height: 60)
                    .font(.system(size: 50))
                    .padding(.bottom, 20)
                
                Button(action: {
                    isPresentedSelect = true //trueにしないと画面遷移されない
                }) {
                    Text("スタート")
                        .frame(width: 200, height: 60)
                        .font(.largeTitle)
                        .overlay(
                            RoundedRectangle(cornerRadius: radius)
                                .stroke(Color.secondary, lineWidth: 2)
                        )
                        .foregroundStyle(Color.white)
                        .background(RoundedRectangle(cornerRadius: radius).fill(Color.blue))
                }
                .fullScreenCover(isPresented: $isPresentedSelect) { //フルスクリーンの画面遷移
                    SelectDifficulty()
                }
                
                Button(action: {
                    isPresentedRecord = true
                }) {
                    Text("記録")
                        .frame(width: 200, height: 60)
                        .font(.largeTitle)
                        .overlay(
                            RoundedRectangle(cornerRadius: radius)
                                .stroke(Color.secondary, lineWidth: 2)
                        )
                        .foregroundStyle(Color.white)
                        .background(RoundedRectangle(cornerRadius: radius).fill(Color.secondary))
                }
                .fullScreenCover(isPresented: $isPresentedRecord) { //フルスクリーンの画面遷移
                    RecordView()
                }
            }
        }
    }
}

#Preview {
    MainMenu()
}
