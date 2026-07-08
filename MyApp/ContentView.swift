//
//  ContentView.swift
//  MyApp
//
//  Created by nv01 on 2026/07/08.
//

import SwiftUI

struct ContentView: View {
    var radius = CGFloat(10)
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color.yellow)
                .ignoresSafeArea()
                .scaledToFill()
            
            VStack{
                Text("game")
                    .frame(width: 200, height: 60)
                    .font(.system(size: 50))
                    .padding(.bottom, 20)
                
                Button(action: {
                }) {
                    Text("スタート")
                }
                .frame(width: 200, height: 60)
                .font(.largeTitle)
                .overlay(
                    RoundedRectangle(cornerRadius: radius)
                        .stroke(Color.secondary, lineWidth: 2)
                )
                .foregroundStyle(Color.white)
                .background(RoundedRectangle(cornerRadius: radius).fill(Color.blue))
                
                Button(action: {
                }) {
                    Text("記録")
                }
                .frame(width: 200, height: 60)
                .font(.largeTitle)
                .overlay(
                    RoundedRectangle(cornerRadius: radius)
                        .stroke(Color.secondary, lineWidth: 2)
                )
                .foregroundStyle(Color.white)
                .background(RoundedRectangle(cornerRadius: radius).fill(Color.secondary))
            }
        }
    }
}

#Preview {
    ContentView()
}
