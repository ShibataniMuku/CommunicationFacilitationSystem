import SwiftUI
import MultipeerConnectivity

struct SearchDeviceView: View {
    @ObservedObject var viewModel = ArrowViewModel()
    @Binding var communicationState: Communication

    @State private var isShowDialog = false
    
    var body: some View {
        ZStack{
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(){
                Text("散策中")
                    .font(.largeTitle)
                    .bold()
                    .padding(.vertical)
                
                Text("あなたと気が合いそうな人が表示されます。\nタップして会いに行ってみましょう。")
                    .padding(.vertical)
                    .multilineTextAlignment(.center)
                
                List(viewModel.availableDevices, id: \.id) { availableDevice in
                    Button(action: {
                        isShowDialog = true
                    }) {
                        AvailableDeviceListNodeView(availableDevice: availableDevice)
                    }.confirmationDialog("\(availableDevice.mcPeerId.displayName)さんに会いに行きますか", isPresented: $isShowDialog, titleVisibility: .visible, actions: {
                        Button("会いに行く"){
                            communicationState = .findingDevice
                            viewModel.connectToPeer(availableDevice.mcPeerId)
                            
                            // 接続しているデバイスとして登録
                            viewModel.connectingDevice = availableDevice
                        }
                        Button("キャンセル", role: .cancel){
                            print("キャンセルしました")
                        }
                        
                    }, message: {
                        Text("通信を開始すると、相手までの距離と方向が表示されます。")
                    })
                }
                .scrollContentBackground(.hidden)
                .environment(\.editMode, .constant(.active))
                
                Spacer()
            }
            .padding()
        }
    }
}
