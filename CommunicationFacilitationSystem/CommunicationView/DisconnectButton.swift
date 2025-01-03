import SwiftUI

struct DisconnectButton: View {
    @ObservedObject var viewModel: ArrowViewModel
    @State var isShowDialog: Bool = false
    @State var isActiveModeSelectView: Bool = false
    
    var body: some View {
        NavigationLink(destination: ModeSelectView(),
                       isActive: $isActiveModeSelectView) {
            EmptyView()
        }
        
        Button(action: {
            isShowDialog = true
            print("会うのをやめる")
        }){
            Text("会うのをやめる")
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .padding(.vertical)
        }
        .confirmationDialog("通信を切断してよろしいですか", isPresented: $isShowDialog, titleVisibility: .visible, actions: {
            Button("切断する"){
                // キャンセルしたことを相手に通知
                guard let peerId = viewModel.connectingDevice?.mcPeerId else {
                    print("利用可能なデバイスがありません")
                    return
                }
                viewModel.sendButtonPress(to: peerId, "cancelMeeting")
                
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
    }
}
