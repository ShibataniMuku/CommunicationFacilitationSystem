import SwiftUI

struct FindingYouView: View {
    @ObservedObject var viewModel: ArrowViewModel
    @State private var isShowDialog = false
    @State private var isActiveModeSelectView = false
    
    var meetingDistance: Float = 1.0
    
    var body: some View {
        NavigationLink(destination: ModeSelectView(),
                       isActive: $isActiveModeSelectView) {
                        EmptyView()
        }
        
        ZStack{
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            if let distance = viewModel.distance {
                VStack(){
                    Text("あなたを探しています")
                        .font(.largeTitle)
                        .bold()
                        .padding(.vertical)
                    Text("あなたの周辺にいるユーザが、あなたを探しています。\n近くに来たら、話しかけてみましょう。")
                        .padding(.vertical)
                        .multilineTextAlignment(.center)
                    Spacer()
                    
                    NavigationLink(destination: DeviceCloserView(viewModel: viewModel)) {
                        Text("出会えた")
                            .fontWeight(.medium)
                            .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
                                   height: 60)
                            .background(distance <= meetingDistance ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(.infinity)
                            .disabled(distance <= meetingDistance)
                    }
                    
                    Button(action: {
                        isShowDialog = true
                    }){
                        Text("会うのをやめる")
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                            .padding(.vertical)
                    }
                    .confirmationDialog("通信を切断してよろしいですか", isPresented: $isShowDialog, titleVisibility: .visible, actions: {
                        Button("切断する"){
                            viewModel.stopSession() // NearbyInteractionを停止
                            isActiveModeSelectView = true
                            print("通信を切断しました")
                        }
                        Button("キャンセル", role: .cancel){

                            print("キャンセルしました")
                        }
                        
                    }, message: {
                        Text("通信を切断すると、通信しているもう一方のユーザが、あなたに会いに来ることができなくなります。")
                    })
                    .navigationBarBackButtonHidden(true)
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
