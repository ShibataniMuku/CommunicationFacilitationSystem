////
////  Test.swift
////  CommunicationFacilitationSystem
////
////  Created by 柴谷 椋 on 2024/12/22.
////
//
//import SwiftUI
//
//struct Test: View {
//    @State var isShowDialog = false
//    
//    var body: some View {
//        ZStack{
//            Color(.systemGroupedBackground)
//                .ignoresSafeArea()
//            
//            VStack(){
//                Spacer()
//                
//                if let distance = viewModel.distance {
//                    if distance <= 0.5 {
//                        Text("すぐ近くにいます")
//                            .font(.largeTitle)
//                            .bold()
//                    } else {
//                        Text("\(distance, specifier: "%.2f") m")
//                            .font(.largeTitle)
//                            .bold()
//                    }
//
//                } else {
//                    Text("距離計測中")
//                        .font(.largeTitle)
//                        .bold()
//                }
//                
//                Spacer()
//                    
//                Image(systemName: "arrowshape.up.fill") // システムアイコンの例
//                    .resizable() // サイズ変更可能にする
//                    .scaledToFit()
//                    .frame(width: UIScreen.main.bounds.size.width / 1.4)
//                    .foregroundColor(.green)
//                
//                Spacer()
//            
//                NavigationLink(destination: RegisteringKeywordView()) {
//                    Button{
//                        
//                    } label: {
//                        Text("出会えた")
//                            .fontWeight(.medium)
//                            .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
//                                   height: UIScreen.main.bounds.size.width / 6 * 1)
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(.infinity)
//                    }
//                }
//                
//                NavigationLink(destination: RegisteringKeywordView()) {
//                    Text("会うのをやめる")
//                        .fontWeight(.medium)
//                        .foregroundColor(.blue)
//                        .padding(.vertical)
//                        .confirmationDialog("通信を切断してよろしいですか", isPresented: $isShowDialog, titleVisibility: .visible, actions: {
//                            Button("切断する"){
//                                print("通信を切断しました")
//                            }
//                            Button("キャンセル", role: .cancel){
//
//                                print("キャンセルしました")
//                            }
//                            
//                        }, message: {
//                            Text("通信を切断すると、通信しているもう一方のユーザが、あなたに会いに来ることができなくなります。")
//                        })
//                }
//            }
//            .padding()
//            .onChange(of: viewModel.distance) { newValue in
//                if let distance = newValue, distance <= 0.1 {
//                    isActivePersonalPasswordView = true // 条件を満たしたら遷移フラグを立てる
//                }
//            }
//        }
//    }
//}
//
//
//#Preview {
//    Test()
//}
