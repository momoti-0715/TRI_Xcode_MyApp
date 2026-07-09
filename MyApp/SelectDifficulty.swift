//
//  SelectDifficulty.swift
//  MyApp
//
//  Created by nv01 on 2026/07/08.
//

import SwiftUI

struct SelectDifficulty: View {
    var radius = CGFloat(10)
    
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
                    }
                }
                
                HStack{
                    ForEach(4..<8, id: \.self) { i in
                        Button(action: {
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
                    }
                }
                
                Button(action: {
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
                }
        }
    }
}

#Preview {
    SelectDifficulty()
}
