//
//  Test.swift
//  CommunicationFacilitationSystem
//
//  Created by 柴谷 椋 on 2024/12/22.
//

import SwiftUI

struct Test: View {
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 70){
                Text("0.0 m")
                    .font(.largeTitle)
                    .bold()
                
                Image(systemName: "arrowshape.up.fill") // システムアイコンの例
                    .resizable() // サイズ変更可能にする
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.size.width / 1.4)
                    .foregroundColor(.green)
            }
        }
    }
}

#Preview {
    Test()
}
