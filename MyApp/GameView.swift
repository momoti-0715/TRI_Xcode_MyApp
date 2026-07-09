//
//  GameView.swift
//  MyApp
//
//  Created by nv01 on 2026/07/08.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        ZStack{
            TimerView()
        }
    }
}

struct TimerView: View{
    @State var timerHandler: Timer?
    @State var count:Double = 0
    @AppStorage("timer_value") var timerValue:Double = 10
    @State var isShowAlert = false
    @State var rTimeText = "0"
    var radius = CGFloat(10)
    let formatter = DateComponentsFormatter()
    
    var buttonNum = 3
    
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
                                Circle().stroke(Color.secondary, lineWidth: 2) // 白い枠線を重ねる
                            )
                            .overlay(
                                Text("10")
                                    .font(.title2)
                            )
                    }
                }
                .padding(.top, 8)
                
                HStack{
                    ForEach(0..<buttonNum / 2, id: \.self) { i in
                        Button(action: {
                        }) {
                            Text("")
                                .frame(width: 80, height: 100)
                                .font(.largeTitle)
                                .overlay(
                                    RoundedRectangle(cornerRadius: radius)
                                        .stroke(Color.secondary, lineWidth: 2)
                                )
                                .foregroundStyle(Color.white)
                                .background(RoundedRectangle(cornerRadius: radius).fill(Color.secondary))
                                .padding([.leading, .trailing], 20)
                        }
                    }
                }
                .padding(.bottom, 8)
                
                HStack{
                    ForEach(buttonNum / 2..<buttonNum, id: \.self) { i in
                        Button(action: {
                        }) {
                            Text("")
                                .frame(width: 80, height: 100)
                                .font(.largeTitle)
                                .overlay(
                                    RoundedRectangle(cornerRadius: radius)
                                        .stroke(Color.secondary, lineWidth: 2)
                                )
                                .foregroundStyle(Color.white)
                                .background(RoundedRectangle(cornerRadius: radius).fill(Color.secondary))
                                .padding([.leading, .trailing], 20)
                        }
                    }
                }
                .padding(.top, 8)
                
                Spacer()
                
                HStack{
                    Button(action: {
                    }) {
                        Text("戻る")
                            .frame(width: 160, height: 50)
                            .font(.title)
                            .overlay(
                                RoundedRectangle(cornerRadius: radius)
                                    .stroke(Color.secondary, lineWidth: 2)
                            )
                            .foregroundStyle(Color.white)
                            .background(RoundedRectangle(cornerRadius: radius).fill(Color.secondary))
                            .padding(.trailing, 40)
                    }
                    
                    Button(action: {
                    }) {
                        Text("リトライ")
                            .frame(width: 160, height: 50)
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
        .alert("完了", isPresented: $isShowAlert){
            Button("OK"){
                print("OKがタップされました")
            }
        } message: {
            Text("おいしくできたよ！")
        }
    }
    
    func startTimer(){
        settingFormatter()
        
        // タイマーをリセットする
        if let timerHandler{
            if timerHandler.isValid == true {
                timerHandler.invalidate()
            }
        }
        count = 0
        
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
            Task{ @MainActor in
                countDownTimer()
                remaining()
            }
        }
    }
    
    func resumptionTimer(){
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
            
            isShowAlert = true
        }
    }
    
    func settingFormatter(){
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.minute, .second]
        formatter.calendar?.locale = Locale(identifier: "ja_JP")
    }
    
    func remaining(){
        let duration: TimeInterval = (timerValue - count)
        
        if let formattedString = formatter.string(from: duration) {
            rTimeText = formattedString
        } else {
            rTimeText = "0秒"
        }
    }
}

#Preview {
    GameView()
}
