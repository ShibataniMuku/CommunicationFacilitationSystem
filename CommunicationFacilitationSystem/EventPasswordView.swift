//
//  EventPasswordView.swift
//  CommunicationFacilitationSystem
//
//  Created by 柴谷 椋 on 2024/12/20.
//

import SwiftUI

struct EventPasswordView: View {
    @State var password: String = ""
    
    var body: some View {
        ZStack{
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack{
                Text("会場で提示されている合言葉を入力してください")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Form{
                    TextField("会場の合言葉", text: $password)
                }
                
                NavigationLink(destination: ModeSelectView()){
                    Text("入力完了")
                        .fontWeight(.medium)
                        .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
                               height: UIScreen.main.bounds.size.width / 6 * 1)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(.infinity)
                }
            }
            .padding()
            .navigationTitle("会場の登録")
        }
    }
}

#Preview {
    NavigationView{
        EventPasswordView()
    }
}
