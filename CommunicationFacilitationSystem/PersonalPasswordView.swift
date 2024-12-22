//
//  PasswordView.swift
//  CommunicationFacilitationSystem
//
//  Created by 柴谷 椋 on 2024/12/20.
//

import SwiftUI

struct PersonalPasswordView: View {
    @State var password: String = ""
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack{
                    Text("パスワードをお互いに交換してください")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Form{
                        TextField("相手のパスワード", text: $password)
                    }
                    
                    NavigationLink(destination: ModeSelectView()){
                        Button{
                            
                        } label: {
                            Text("入力完了")
                                .fontWeight(.medium)
                                .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
                                       height: UIScreen.main.bounds.size.width / 6 * 1)
                                .background(password != "" ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(.infinity)
                        }
                        .padding()
                        .disabled(password != "")
                    }
                }
                .navigationTitle("出会えた確認")
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationView{
        PersonalPasswordView()
    }
}
