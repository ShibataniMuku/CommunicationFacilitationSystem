import SwiftUI
import MultipeerConnectivity
import NearbyInteraction

struct ArrowView: View {
    @StateObject private var viewModel = ArrowViewModel()
    @State private var selectedPeer: MCPeerID? = nil
    @State var isShowDialog = false

    var body: some View {
        NavigationLink(destination: FindingYouView(viewModel: viewModel),
                       isActive: $viewModel.isConnectionRequested) {
                        EmptyView()
        }
        
        VStack {
            if let selectedPeer = selectedPeer {
                // 接続が確立されたら，矢印の画面へ遷移
                MeasureView(viewModel: viewModel, isShowDialog: isShowDialog)
            } else {
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
                                    selectedPeer = availableDevice.mcPeerId
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
        .onAppear {
            viewModel.startBrowsing()
        }
        .onDisappear {
            viewModel.stopBrowsing()
        }
    }
}
