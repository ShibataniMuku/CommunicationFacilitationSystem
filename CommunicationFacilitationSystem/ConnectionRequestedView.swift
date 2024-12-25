import SwiftUI

struct ConnectionRequestedView: View {
    @State var isShowDialog = false
    @State var isActiveModeSelectView = false
    
    let arrowViewModel: ArrowViewModel

    var body: some View {
        NavigationLink(destination: ModeSelectView(),
                       isActive: $isActiveModeSelectView) {
                        EmptyView()
        }
        
        ZStack{
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            if let distance = arrowViewModel.distance, distance <= 0.1 {
                VStack(){
                    Text("出会いました")
                        .font(.largeTitle)
                        .bold()
                        .padding(.vertical)
                    Text("で会うことができました。")
                        .padding(.vertical)
                        .multilineTextAlignment(.center)
                    Spacer()
                    
                    NavigationLink(destination: RegisteringKeywordView()) {
                        Button{
                            
                        } label: {
                            Text("ホームへ戻る")
                                .fontWeight(.medium)
                                .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
                                       height: UIScreen.main.bounds.size.width / 6 * 1)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(.infinity)
                        }
                    }
                }
                .padding()
            } else {
                VStack(){
                    Text("あなたを探しています")
                        .font(.largeTitle)
                        .bold()
                        .padding(.vertical)
                    Text("あなたの周辺にいるユーザが、あなたを探しています。近くに来たら、話しかけてみましょう。")
                        .padding(.vertical)
                        .multilineTextAlignment(.center)
                    Spacer()
                    
                    NavigationLink(destination: RegisteringKeywordView()) {
                        Button{
                            
                        } label: {
                            Text("出会えた")
                                .fontWeight(.medium)
                                .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
                                       height: UIScreen.main.bounds.size.width / 6 * 1)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(.infinity)
                        }
                    }
                    
                    NavigationLink(destination: RegisteringKeywordView()) {
                        Text("会うのをやめる")
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                            .padding(.vertical)
                            .confirmationDialog("通信を切断してよろしいですか", isPresented: $isShowDialog, titleVisibility: .visible, actions: {
                                Button("切断する"){
                                    isActiveModeSelectView = true
                                    print("通信を切断しました")
                                }
                                Button("キャンセル", role: .cancel){

                                    print("キャンセルしました")
                                }
                                
                            }, message: {
                                Text("通信を切断すると、通信しているもう一方のユーザが、あなたに会いに来ることができなくなります。")
                            })
                    }
                }
                .padding()
            }
        }
    }
}
