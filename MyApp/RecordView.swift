//
//  RecordView.swift
//  MyApp
//
//  Created by nv01 on 2026/07/08.
//

import SwiftUI

struct RecordView: View {
    @State var selectButton = 1
    @State var dataArray: [[String]] = [
            ["A1", "A2"],
            ["B1", "B2"],
            ["C1", "C2ああああああああああああ"],
            ["A1", "A2"],
            ["B1", "B2"],
            ["C1", "C2"]
       ]
    let columnWidths: [CGFloat] = [
        640.0 * 0.75,
        640.0 * 0.25,
    ]
    

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
            }
            .padding(.top, 30)
            .padding(.bottom, 10)
            .frame(width: 640)
        }
    }
}

struct Test: View {
    let columnWidths: [CGFloat] = [160, 80]
    let twoDimensionalArray: [[String]] = [
            ["A1", "A2"],
            ["B1", "B2"],
            ["C1", "C2ああああああああああああ"],
            ["A1", "A2"],
            ["B1", "B2"],
            ["C1", "C2"]
       ]

    var body: some View {
            ScrollView([.vertical, .horizontal]) {
                Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                    ForEach(twoDimensionalArray.indices, id: \.self) { rowIndex in
                        GridRow {
                            ForEach(twoDimensionalArray[rowIndex].indices, id: \.self) { colIndex in
                                let cellText = twoDimensionalArray[rowIndex][colIndex]
                                
                                // 2. 列番号（colIndex）に応じて、指定した異なる幅を自動取得
                                let width = columnWidths[colIndex]
                                
                                Text(cellText)
                                    .font(.body)
                                    .fontWeight(.regular)
                                    // 3. 取得した個別の幅をセルに適用
                                    //（ヘッダーは中央寄せ、データ行は左寄せ）
                                    .frame(width: width, height: 50)
                                    .padding(.horizontal, 8) // 文字と枠線の間の余白
                                    .frame(width: width) // 余白を含めた全体の幅を固定
                                    .background(Color.clear)
                                    .border(Color.gray, width: 0.5) // 表の罫線
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
#Preview {
    RecordView()
}
