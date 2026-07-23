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
        }
        .onChange(of: selectButton) { _, value in
            dataArray = userDefaults.array(forKey: "score\(value)") as? [[String]] ?? [[]]
            
            for _ in 0...(5-dataArray.count){   // データがないとその分表が表示されないので画面を埋める分だけ追加する
                dataArray.append(Array(repeating: "", count: 2))
            }
        }
    }
}

#Preview {
    RecordView()
}
