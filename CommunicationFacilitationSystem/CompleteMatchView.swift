//
//  CompleteMatchView.swift
//  CommunicationFacilitationSystem
//
//  Created by 柴谷 椋 on 2024/12/23.
//

import SwiftUI

struct CompleteMatchView: View {
    @State var isActiveModeSelectView: Bool = false
    
    var body: some View {
        NavigationLink(destination: ModeSelectView(),
                       isActive: $isActiveModeSelectView) {
                        EmptyView()
        }
        
        ZStack{
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(){
                Text("デバイスを近づける")
                    .font(.largeTitle)
                    .bold()
                    .padding(.vertical)
                Text("デバイス同士を近づけて、出会ったことを確定させましょう。")
                    .padding(.vertical)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    CompleteMatchView()
}
