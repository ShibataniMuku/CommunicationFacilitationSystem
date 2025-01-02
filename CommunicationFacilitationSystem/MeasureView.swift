import SwiftUI

struct MeasureView: View {
    @ObservedObject var viewModel: ArrowViewModel
    @State var isShowDialog: Bool
    @State var isActiveModeSelectView: Bool = false
    
    var meetingDistance: Float = 1.0
    
    var body: some View {
        NavigationLink(destination: ModeSelectView(),
                       isActive: $isActiveModeSelectView) {
                        EmptyView()
        }
        
        NavigationLink(destination: ModeSelectView(),
                       isActive: $viewModel.isCancelledMeeting) {
                        EmptyView()
        }
        
        ZStack{
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
                
            if let distance = viewModel.distance {
                VStack(){
                    Spacer()
                    if distance <= 1 {
                        Text("すぐ近くにいます")
                            .font(.largeTitle)
                            .bold()
                    } else {
                        Text("\(distance, specifier: "%.2f") m")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    if let direction = viewModel.direction {
                        Text("x: \(direction.x), y: \(direction.y), z: \(direction.z)")
                    } else {
//                        Text("方向取得中...")
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrowshape.up.fill") // システムアイコンの例
                        .resizable() // サイズ変更可能にする
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.size.width / 1.4)
                        .foregroundColor(.green)
                    
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
                    .navigationBarBackButtonHidden(true)
                }
                .padding()
            } else {
                HStack{
                    ProgressView("相手のデバイスと接続中です")
                }
            }
        }
    }
}
