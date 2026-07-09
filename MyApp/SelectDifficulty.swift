//
//  SelectDifficulty.swift
//  MyApp
//
//  Created by nv01 on 2026/07/08.
//

import SwiftUI

struct SelectDifficulty: View {
    @State private var isPresentedGame: Bool = false    // 画面遷移の時に使用するbool値
    @State private var isPresentedMain: Bool = false
    let radius = CGFloat(10)
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color.yellow)
                .ignoresSafeArea()
            
            VStack{
                Text("難易度選択")
                    .frame(width: 200, height: 60)
                    .font(.largeTitle)
                
                HStack{
                    ForEach(0..<4, id: \.self) { i in
                        Button(action: {
                            isPresentedGame = true
                        }) {
                            Text("\(i + 1)")
                                .frame(width: 80, height: 80)
                                .font(.largeTitle)
                                .overlay(
                                    RoundedRectangle(cornerRadius: radius)
                                        .stroke(Color.secondary, lineWidth: 2)
                                )
                                .foregroundStyle(Color.white)
                                .background(RoundedRectangle(cornerRadius: radius).fill(Color.mint))
                                .padding(10)
                        }
                        .fullScreenCover(isPresented: $isPresentedGame) {
                            GameView(difficulty: i + 1)
                        }
                    }
                }
                
                HStack{
                    ForEach(4..<8, id: \.self) { i in
                        Button(action: {
                            isPresentedGame = true
                        }) {
                            Text("\(i + 1)")
                                .frame(width: 80, height: 80)
                                .font(.largeTitle)
                                .overlay(
                                    RoundedRectangle(cornerRadius: radius)
                                        .stroke(Color.secondary, lineWidth: 2)
                                )
                                .foregroundStyle(Color.white)
                                .background(RoundedRectangle(cornerRadius: radius).fill(Color.mint))
                                .padding(10)
                        }
                        .fullScreenCover(isPresented: $isPresentedGame) {
                            GameView(difficulty: i + 1)
                        }
                    }
                }
                
                Button(action: {
                    isPresentedMain = true
                }) {
                    Text("戻る")
                        .frame(width: 160, height: 60)
                        .font(.largeTitle)
                        .overlay(
                            RoundedRectangle(cornerRadius: radius)
                                .stroke(Color.secondary, lineWidth: 2)
                        )
                        .foregroundStyle(Color.white)
                        .background(RoundedRectangle(cornerRadius: radius).fill(Color.gray))
                        .padding(.top, 10)
                }
                .fullScreenCover(isPresented: $isPresentedMain) { //フルスクリーンの画面遷移
                    ContentView()
                }
            }
        }
    }
}

#Preview {
    SelectDifficulty()
}
