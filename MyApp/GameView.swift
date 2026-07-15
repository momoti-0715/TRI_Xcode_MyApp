//
//  GameView.swift
//  MyApp
//
//  Created by nv01 on 2026/07/08.
//

import SwiftUI
import Combine

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
    
    @StateObject private var game = Game()
    
    @State private var isPresented: Bool = false
    @State private var hasStarted = false
    
    let radius = CGFloat(10)
    
    var body: some View{
        ZStack{
            Rectangle()
                .foregroundColor(Color.yellow)
                .ignoresSafeArea()
            
            VStack{
                ZStack{
                    Text(game.sw.stopWatchText)
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
                                Text(game.ct.rTimeText)
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
                            VStack{
                                Text("10")
                                    .font(.title)
                                    .padding(.bottom, 1)
                                Text("±00.00")
                                    .font(.title3)
                            }
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
                            VStack{
                                Text("10")
                                    .font(.title)
                                    .padding(.bottom, 1)
                                Text("±00.00")
                                    .font(.title3)
                            }
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
                        game.sw.stopTimer()
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
                        game.ct.rTimeText = "10"
                        game.start()
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
                game.start()
            }
        }
    }
}

class Game: ObservableObject{
    @Published var ct = CountTimer()
    @Published var sw = StopWatch()
    
    private var cancellable: AnyCancellable?

    // Gameを仲介させて値を渡す処理
    init() {
        // カウントタイマーの変更をGameへ伝える
        cancellable = Publishers.Merge(
            ct.objectWillChange,
            sw.objectWillChange
        )
        .sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    func start(){
        sw.stopTimer()   // 動いていたら停止
        sw.time = 0      // 必要ならリセット
        sw.stopWatchText = "0.00"
        
        ct.startTimer()
        ct.sw = sw
    }
}

class CountTimer: ObservableObject {
    private var timerHandler: Timer?
    
    var sw = StopWatch()
    
    private var cancellable: AnyCancellable?
    
    @Published var rTimeText = "10"
    var count = 0
    var timerValue = 10
    
    init() {
        cancellable = sw.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
    }

    func startTimer(){
        count = 0
        
        if let timerHandler {
            timerHandler.invalidate()
        }
        
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
            Task { @MainActor in
                self.countDownTimer()
                self.remaining()
            }
        }
    }

    func countDownTimer(){
        count += 1
        
        if timerValue - count <= 0 {
            timerHandler?.invalidate()
            sw.startTimer()
        }
    }

    func remaining(){
        rTimeText = String(timerValue - count)
        print(rTimeText)
    }
}

class StopWatch: ObservableObject {
    private var timerHandler: Timer?
    
    var time:Double = 0
    let interval:Double = 0.01
    
    @Published var stopWatchText = "0.00"

    func startTimer(){
        self.time = 0
        
        if let timerHandler {
            timerHandler.invalidate()
        }
        
        timerHandler = Timer.scheduledTimer(withTimeInterval: interval, repeats: true){ _ in
            Task { @MainActor in
                self.count()
            }
        }
    }
    
    func count(){
        time += interval
        stopWatchText = String(format: "%.2f", time)
        print(stopWatchText)
    }
    
    func stopTimer(){
        if let timerHandler {
            timerHandler.invalidate()
        }
    }
}

#Preview {
    GameView(difficulty: 6)
}
