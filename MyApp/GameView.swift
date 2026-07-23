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
    
    @StateObject private var game:Game
    
    @State private var isPresented: Bool = false
    @State private var hasStarted = false
    @State var buttonEnable: [Bool] = []
    @State private var isFadedOut = false   // フェードアウト状態を管理するフラグ
    @State private var buttonVisible = false    // リトライボタンなどのボタンの表示切り換え
    @State private var targetLavelVisible = true    // 目標時間の表示切り替え
    @State private var resultLavelVisible = false    // 時差の表示切り替え
    
    let radius = CGFloat(10)
    
    init(buttonNum: Int) {
        self.buttonNum = buttonNum
        _buttonEnable = State(initialValue: Array(repeating: false, count: buttonNum))
        _game = StateObject(wrappedValue: Game(buttonNum: buttonNum))
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
                        .opacity(isFadedOut ? 0 : 1) // フラグに応じて透明度を変更
                        .animation(.easeOut(duration:isFadedOut ? 2.0 : 0), value: isFadedOut) // フェードアウトのアニメーション
                                    
                    HStack{
                        if resultLavelVisible{
                            Text(String(format: "時差の合計：%.2f", game.score))
                                .font(.title3)
                        }
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
                            game.recordTime(i)
                        }) {
                            VStack{
                                if targetLavelVisible{
                                    Text("\(game.targetTime[i])")
                                        .font(.title)
                                        .padding(.bottom, 1)
                                }
                                if resultLavelVisible{
                                    Text("\(game.diffTime[i])")
                                        .font(.title3)
                                }
                            }
                            .frame(width: 80, height: 100)
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
                            game.recordTime(i)
                        }) {
                            VStack{
                                if targetLavelVisible{
                                    Text("\(game.targetTime[i])")
                                        .font(.title)
                                        .padding(.bottom, 1)
                                }
                                if resultLavelVisible{
                                    Text("\(game.diffTime[i])")
                                        .font(.title3)
                                }
                            }
                            .frame(width: 80, height: 100)
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
                    if buttonVisible{
                        Button(action: {
                            isPresented = true
                            game.sw.stopTimer()
                            game.ct.stopTimer()
                        }) {
                            Text("メインメニュー")
                                .font(.title)
                            
                        }
                        .frame(width: 200, height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: radius)
                                .stroke(Color.secondary, lineWidth: 2)
                        )
                        .foregroundStyle(Color.white)
                        .background(RoundedRectangle(cornerRadius: radius).fill(Color.secondary))
                        .padding(.trailing, 40)
                        .fullScreenCover(isPresented: $isPresented) {
                            ContentView()
                        }
                        
                        Button(action: {
                            game.ct.rTimeText = "10"
                            game.start()
                        }) {
                            Text("リトライ")
                                .font(.title)
                        }
                        .frame(width: 200, height: 50)
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
        .onChange(of: game.isRunning, { _, running in
            if running{
                buttonVisible = false
                resultLavelVisible = false
                
                game.setTargetTime()
                game.resetVariable()
            } else {
                buttonVisible = true
                resultLavelVisible = true
            }
        })
        .onChange(of: game.sw.isRunning) { _, running in
            if running {
                buttonEnable = Array(repeating: true, count: buttonNum)
                targetLavelVisible = false
            } else {
                targetLavelVisible = true
            }
        }
        .onChange(of: game.sw.time, { _, value in
            if !isFadedOut && value > 8{
                isFadedOut = true
            }
        })
        .onChange(of: buttonEnable) { _, value in
            if game.sw.isRunning && value.allSatisfy({ !$0 }) {
                game.end()
                isFadedOut = false
            }
        }
    }
}

class Game: ObservableObject{
    @Published var ct = CountTimer()
    @Published var sw = StopWatch()
    @Published var isRunning = false
    @Published var score:Double = 0
    @Published var targetTime: [Int] = []   // buttonの目標時間
    @Published var diffTime:[String] = []
    private var pushTime:[Double] = []   // buttonを押した時間
    private var cancellable: AnyCancellable?
    private var difficulty:Int
    private var userDefaults = UserDefaults.standard
    private var playDate = Date()
    private let dateFormatter = DateFormatter()

    // Gameを仲介させて値を渡す処理
    init(buttonNum:Int) {
        difficulty = buttonNum
        pushTime = Array(repeating: 0.0, count: difficulty)
        diffTime = Array(repeating: "0.00", count: difficulty)
        targetTime = Array(repeating: 0, count: difficulty)
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMdHms", options: 0, locale: Locale(identifier: "ja_JP"))

        
        // カウントタイマーの変更をGameへ伝える
        cancellable = Publishers.Merge(
            ct.objectWillChange,
            sw.objectWillChange
        )
        .sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    func setTargetTime(){
        targetTime = Array(11..<60)
            .shuffled()
            .prefix(difficulty)
            .map { $0 }
    }
    
    func recordTime(_ buttonNum:Int){
        pushTime[buttonNum] = sw.time
    }
    
    func getScore(){
        for i in 0..<difficulty {
            let diff = pushTime[i] - Double(targetTime[i])
            
            if diff < 0{
                diffTime[i] = String(format: "%.2f", diff)
            } else {
                diffTime[i] = String(format: "+%.2f", diff)
            }
            
            score += abs(diff)
        }
    }
    
    func recordScore(){ // スコアを記録しておく
        let dateText = "\(dateFormatter.string(from: playDate))"    // 日付のフォーマット
        var data = userDefaults.array(forKey: "score\(difficulty)") as? [[String]] ?? [[]]  // データの取得
        data.append([dateText, String(format: "%.2f", score)])  // データの追加
        userDefaults.set(data, forKey: "score\(difficulty)")    // データのセット
    }
    
    func resetVariable(){
        pushTime = Array(repeating: 0.0, count: difficulty)
        diffTime = Array(repeating: "0.00", count: difficulty)
        score = 0
        sw.time = 0      // 必要ならリセット
        sw.stopWatchText = "0.00"
        playDate = Date()
    }
    
    func start(){
        isRunning = true
        sw.stopTimer()   // 動いていたら停止
        ct.sw = sw
        ct.startTimer()
    }
    
    func end(){
        isRunning = false
        sw.stopTimer()
        getScore()
        recordScore()
    }
}

class CountTimer: ObservableObject {
    @Published var rTimeText = "10"
    
    var sw = StopWatch()
    
    private var cancellable: AnyCancellable?
    private var timerHandler: Timer?
    
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
    @Published var time:Double = 0
    
    private var timerHandler: Timer?
    
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
