//
//  GameView.swift
//  MyApp
//
//  Created by nv01 on 2026/07/08.
//

import SwiftUI

struct GameView: View {
    var difficulty:Int
    
    var body: some View {
        ZStack{
            TimerView(buttonNum: difficulty)
        }
    }
}

struct TimerView: View{
    var buttonNum:Int
    
    @State var timerHandler: Timer?
    @State var count = 0
    @State var timerValue = 10
    @State var rTimeText = "10"
    @State private var isPresented: Bool = false
    @State private var hasStarted = false
    @State private var hasTimerStarted = false
    
    let rangeTime = 60
    let radius = CGFloat(10)
    
    var body: some View{
        ZStack{
            Rectangle()
                .foregroundColor(Color.yellow)
                .ignoresSafeArea()
            
            VStack{
                ZStack{
                    Text("0.00")
                        .font(.title)
                    HStack{
                        Spacer()
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Circle().stroke(Color.secondary, lineWidth: 2)
                            )
                            .overlay(
                                Text(rTimeText)
                                    .font(.title2)
                            )
                    }
                }
                .padding(.top, 8)
                
                
                if buttonNum == 1 {
                    Spacer()
                }
                
                HStack{
                    ForEach(0..<buttonNum / 2, id: \.self) { i in
                        Button(action: {
                        }) {
                            Text("")
                                .font(.largeTitle)
                        }
                        .frame(width: 80, height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: radius)
                                .stroke(Color.secondary, lineWidth: 2)
                        )
                        .foregroundStyle(Color.white)
                        .background(RoundedRectangle(cornerRadius: radius).fill(Color.secondary))
                        .padding([.leading, .trailing], 20)
                    }
                }
                .padding(.bottom, 8)
                
                HStack{
                    ForEach(buttonNum / 2..<buttonNum, id: \.self) { i in
                        Button(action: {
                        }) {
                            Text("")
                                .font(.largeTitle)
                        }
                        .frame(width: 80, height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: radius)
                                .stroke(Color.secondary, lineWidth: 2)
                        )
                        .foregroundStyle(Color.white)
                        .background(RoundedRectangle(cornerRadius: radius).fill(Color.secondary))
                        .padding([.leading, .trailing], 20)
                    }
                }
                .padding(.top, 8)
                
                Spacer()
                
                HStack{
                    Button(action: {
                        isPresented = true
                    }) {
                        Text("メインメニュー")
                            .frame(width: 200, height: 50)
                            .font(.title)
                            .overlay(
                                RoundedRectangle(cornerRadius: radius)
                                    .stroke(Color.secondary, lineWidth: 2)
                            )
                            .foregroundStyle(Color.white)
                            .background(RoundedRectangle(cornerRadius: radius).fill(Color.secondary))
                            .padding(.trailing, 40)
                    }
                    .fullScreenCover(isPresented: $isPresented) {
                        ContentView()
                    }
                    
                    Button(action: {
                        rTimeText = "10"
                        startTimer()
                    }) {
                        Text("リトライ")
                            .frame(width: 200, height: 50)
                            .font(.title)
                            .overlay(
                                RoundedRectangle(cornerRadius: radius)
                                    .stroke(Color.secondary, lineWidth: 2)
                            )
                            .foregroundStyle(Color.white)
                            .background(RoundedRectangle(cornerRadius: radius).fill(Color.blue))
                            .padding(.leading, 40)
                    }
                }
            }
        }
        .onAppear {
            if !hasStarted {
                hasStarted = true
                startTimer()
            }
        }
    }
    
    func startTimer(){
        count = 0
        
        // タイマーをリセットする
        if let timerHandler{
            if timerHandler.isValid == true {
                timerHandler.invalidate()
            }
        }
        
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
            Task{ @MainActor in
                countDownTimer()
                remaining()
            }
        }
    }
    
    func countDownTimer(){
        count += 1
        
        if timerValue - count <= 0{
            timerHandler?.invalidate()
            
            if !hasTimerStarted{
                hasTimerStarted = true
                // timer開始
            }
        }
    }
    
    func remaining(){
        rTimeText = String("\(timerValue - count)")
    }
}

#Preview {
    GameView(difficulty: 6)
}
