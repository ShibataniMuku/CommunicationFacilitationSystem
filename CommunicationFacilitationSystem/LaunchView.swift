//
//  LaunchView.swift
//  CommunicationFacilitationSystem
//
//  Created by 柴谷 椋 on 2024/12/20.
//

import SwiftUI

struct LaunchView: View {
    @AppStorage("MyName") var myName: String = ""
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack{
                    Spacer()
                    
                    NavigationLink(destination: RegisteringMyNameView()){
                        Text("新しくはじめる")
                            .fontWeight(.medium)
                            .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
                                   height: UIScreen.main.bounds.size.width / 6 * 1)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(.infinity)
                    }
                    
                    NavigationLink(destination: EventPasswordView()){
                        Text("前回と同じ設定ではじめる")
                            .fontWeight(.medium)
                            .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
                                   height: UIScreen.main.bounds.size.width / 6 * 1)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(.infinity)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    LaunchView()
}
