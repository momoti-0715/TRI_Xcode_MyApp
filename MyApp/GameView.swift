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
    let formatter = DateComponentsFormatter()
    
    var body: some View{
        ZStack{
            Rectangle()
                .foregroundColor(Color.yellow)
                .ignoresSafeArea()
                .scaledToFill()
                
            VStack{
                HStack{
                    Button(action: {
                    }) {
                    }
                }
                
                Text("\(rTimeText)")
                    .foregroundColor(Color.black)
                    .onTapGesture {
                        if let timerHandler {   // timerを止める
                            if timerHandler.isValid == true {
                                timerHandler.invalidate()
                            } else {
                                resumptionTimer()
                            }
                        }
                    }
                
                HStack{
                    Button(action: {
                    }) {
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
