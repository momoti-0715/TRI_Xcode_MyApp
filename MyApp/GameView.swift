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
    @State var buttonEnable: [Bool] = []
    
    let radius = CGFloat(10)
    
    init(buttonNum: Int) {
        self.buttonNum = buttonNum
        _buttonEnable = State(initialValue: Array(repeating: false, count: buttonNum))
    }
    
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
                            buttonEnable[i] = false
                        }) {
                            VStack{
                                Text("10")
                                    .font(.title)
                                    .padding(.bottom, 1)
                                Text("±00.00")
                                    .font(.title3)
                            }
                        }
                        .disabled(!buttonEnable[i])
                        .frame(width: 80, height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: radius)
                                .stroke(Color.secondary, lineWidth: 2)
                        )
                        .foregroundStyle(Color.white)
                        .background(RoundedRectangle(cornerRadius: radius).fill(buttonEnable[i] ? Color.cyan : Color.secondary))
                        .padding([.leading, .trailing], 20)
                    }
                }
                .padding(.bottom, 8)
                
                HStack{
                    ForEach(buttonNum / 2..<buttonNum, id: \.self) { i in
                        Button(action: {
                            buttonEnable[i] = false
                        }) {
                            VStack{
                                Text("10")
                                    .font(.title)
                                    .padding(.bottom, 1)
                                Text("±00.00")
                                    .font(.title3)
                            }
                        }
                        .disabled(!buttonEnable[i]) // 有効/無効の切り替え
                        .frame(width: 80, height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: radius)
                                .stroke(Color.secondary, lineWidth: 2)
                        )
                        .foregroundStyle(Color.white)
                        .background(RoundedRectangle(cornerRadius: radius).fill(buttonEnable[i] ? Color.cyan : Color.secondary))
                        .padding([.leading, .trailing], 20)
                    }
                }
                .padding(.top, 8)
                
                Spacer()
                
                HStack{
                    Button(action: {
                        isPresented = true
                        game.sw.stopTimer()
                        game.ct.stopTimer()
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
        .onChange(of: game.sw.isRunning) { _, running in
            if running {
                buttonEnable = Array(repeating: true, count: buttonNum)
            }
        }
        .onChange(of: buttonEnable) { _, value in
            if game.sw.isRunning && value.allSatisfy({ !$0 }) {
                game.end()
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
    
    func end(){
        sw.stopTimer()
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
        
        timerHandler?.invalidate()
        
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
//        print(rTimeText)
    }
    
    func stopTimer(){
        timerHandler?.invalidate()
    }
}

class StopWatch: ObservableObject {
    @Published var stopWatchText = "0.00"
    @Published var isRunning = false
    
    private var timerHandler: Timer?
    
    var time:Double = 0
    let interval:Double = 0.01

    func startTimer(){
        self.time = 0
        isRunning = true
        
        timerHandler?.invalidate()
        
        timerHandler = Timer.scheduledTimer(withTimeInterval: interval, repeats: true){ _ in
            Task { @MainActor in
                self.count()
            }
        }
    }
    
    func count(){
        time += interval
        stopWatchText = String(format: "%.2f", time)
//        print(stopWatchText)
    }
    
    func stopTimer(){
        timerHandler?.invalidate()
        isRunning = false
    }
}

#Preview {
    GameView(difficulty: 6)
}
