//
//  RecordView.swift
//  MyApp
//
//  Created by nv01 on 2026/07/08.
//

import SwiftUI

struct RecordView: View {
    @State var selectButton = 1
    @State private var isPresented: Bool = false
    @State var dataArray: [[String]] = []
    @State var playData: [[String]] = []
    @State var sortDate:Int = 0
    @State var sortResult:Int = 0
    private let tableWidth: CGFloat = 640
    private var columnWidths: [CGFloat] {
        [
            tableWidth * 0.75,
            tableWidth * 0.25
        ]
    }
    private var userDefaults = UserDefaults.standard
    let radius = CGFloat(10)

    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color.yellow)
                .ignoresSafeArea()
            
            VStack(spacing: 0){
                HStack(spacing: 0){
                    ForEach(1...8, id: \.self) { i in
                        Button(action: {
                            selectButton = i
                        }) {
                            Text("\(i)")
                                .frame(width: 80, height: 30)
                                .font(.title3)
                                .foregroundStyle(Color.black)
                                .background(selectButton == i ? Color.white : Color.gray)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 0)
                                        .stroke(selectButton == i ? Color.orange : Color.secondary, lineWidth: selectButton == i ? 3 : 2)
                                )
                        }
                    }
                }
                
                HStack(spacing: 0){
                    Text("プレイ時刻")
                        .frame(width: columnWidths[0], height: 30)
                        .font(.title3)
                        .foregroundStyle(Color.black)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                    
                    Text("結果")
                        .frame(width: columnWidths[1], height: 30)
                        .font(.title3)
                        .foregroundStyle(Color.black)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                }
                
                ScrollView() {
                    Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                        ForEach(dataArray.indices, id: \.self) { rowIndex in
                            GridRow {
                                ForEach(dataArray[rowIndex].indices, id: \.self) { colIndex in
                                    let cellText = dataArray[rowIndex][colIndex]
                                    let width = columnWidths[colIndex]
                                    
                                    Text(cellText)
                                        .font(.body)
                                        .fontWeight(.regular)
                                    // 3. テキストが長すぎる場合に自動改行させて「...」になるのを防ぐ
                                        .lineLimit(nil)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: width, height: 50)
                                        .background(Color.white)
                                        .border(Color.gray, width: 0.5)
                                }
                            }
                        }
                    }
                }
                .padding(.bottom, 10)
                
                Button(action: {
                    isPresented = true
                }) {
                    Text("戻る")
                        .frame(width: 160, height: 40)
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
            }
            .padding(.top, 30)
            .frame(width: 640)
            
            // 右側に配置するソート
            HStack {
                Spacer()
                
                VStack {
                    Text("ソート")
                        .frame(width:55)
                        .background(Color.white)
                    
                    Button(action:{
                        if sortDate == 0 || sortDate == 3{
                            sortDate = 1
                        } else if sortDate == 1{
                            sortDate = 2
                        } else {
                            sortDate = 3
                        }
                        
                        sortResult = 0
                    }){
                        if sortDate == 1 {
                            Text("時刻 ▲")    // 昇順
                        } else if sortDate == 2 {
                            Text("時刻 ▼")    // 降順（新しい順）のとき
                        } else {
                            Text("時刻")  // ソートOFF
                        }
                    }
                    .frame(width:55)
                    .foregroundStyle(Color.black)
                    .background(Color.orange)
                    
                    Button(action:{
                        if sortResult == 0 || sortResult == 3{
                            sortResult = 1
                        } else if sortResult == 1{
                            sortResult = 2
                        } else {
                            sortResult = 3
                        }
                        
                        sortDate = 0
                    }){
                        if sortResult == 1 {
                            Text("結果 ▲")    // 昇順
                        } else if sortResult == 2 {
                            Text("結果 ▼")    // 降順
                        } else {
                            Text("結果")  // ソートOFF
                        }
                    }
                    .frame(width:55)
                    .foregroundStyle(Color.black)
                    .background(Color.orange)
                }
                .frame(width: 56)
            }
        }
        .onAppear(){
            getData(1)
            adjust()
        }
        .onChange(of: selectButton) { _, value in
            getData(value)
            adjust()
        }
        .onChange(of: sortDate){ _, value in
            if playData.count > 1 {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/M/d H:mm:ss"
                
                if value == 1 {
                    // 時刻：昇順（古い順）
                    playData.sort {
                        let date1 = formatter.date(from: $0[0]) ?? Date.distantPast
                        let date2 = formatter.date(from: $1[0]) ?? Date.distantPast
                        return date1 < date2
                    }
                } else if value == 2 {
                    // 時刻：降順（新しい順）
                    playData.sort {
                        let date1 = formatter.date(from: $0[0]) ?? Date.distantPast
                        let date2 = formatter.date(from: $1[0]) ?? Date.distantPast
                        return date1 > date2
                    }
                } else if value == 3{
                    // デフォルト（不要なら削除するか、日付降順などにする）
                    playData.sort { ($0[0]) > ($1[0]) }
                }
            }
            
            adjust()
        }
        .onChange(of: sortResult){ _, value in
            if playData.count > 1 {
                if value == 1 {
                    // 結果：昇順（数値が小さい順）
                    playData.sort {
                        // Double型（小数）として正しく変換して比較します
                        let num1 = Double($0[1]) ?? Double.greatestFiniteMagnitude
                        let num2 = Double($1[1]) ?? Double.greatestFiniteMagnitude
                        return num1 < num2
                    }
                } else if value == 2 {
                    // 結果：降順（数値が大きい順）
                    playData.sort {
                        let num1 = Double($0[1]) ?? -Double.greatestFiniteMagnitude
                        let num2 = Double($1[1]) ?? -Double.greatestFiniteMagnitude
                        return num1 > num2
                    }
                } else if value == 3{
                    // デフォルト（日付降順などに戻す）
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/M/d H:mm:ss"
                    playData.sort {
                        let date1 = formatter.date(from: $0[0]) ?? Date.distantPast
                        let date2 = formatter.date(from: $1[0]) ?? Date.distantPast
                        return date1 > date2
                    }
                }
            }
            
            adjust()
        }
    }
    
    func getData(_ value:Int){
        playData = userDefaults.array(forKey: "score\(value)") as? [[String]] ?? []
    }
    
    func adjust(){
        dataArray = playData
        
        let range = 5 - dataArray.count
        if range > 0 {
            for _ in 0..<(range){   // データがないとその分表が表示されないので画面を埋める分だけ追加する
                dataArray.append(Array(repeating: "", count: 2))
            }
        }
    }
}

#Preview {
    RecordView()
}
