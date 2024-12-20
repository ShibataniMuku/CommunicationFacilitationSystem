//
//  ArrowView.swift
//  CommunicationFacilitationSystem
//
//  Created by 柴谷 椋 on 2024/12/20.
//

import SwiftUI
import MultipeerConnectivity

struct ArrowView: View {
    var body: some View {
        ZStack{
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack{
                Text("0.0 m")
                    .font(.largeTitle)
                    .bold()
                
                Image(systemName: "arrowshape.up.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(80)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.green)
            }
            
            VStack{
                Spacer()
                
                NavigationLink(destination: PersonalPasswordView()){
                    Text("出会えた")
                        .fontWeight(.medium)
                        .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
                               height: UIScreen.main.bounds.size.width / 6 * 1)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(.infinity)
                }
            }
        }
    }
}

#Preview {
    ArrowView()
}
