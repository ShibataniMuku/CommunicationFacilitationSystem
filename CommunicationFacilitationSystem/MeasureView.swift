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
        
        ZStack{
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(){
                Spacer()
                
                if let distance = viewModel.distance {
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
                        Text("方向取得中...")
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
                            viewModel.stopSession() // NearbyInteractionを停止
                            isActiveModeSelectView = true
                        }
                        Button("キャンセル", role: .cancel){

                            print("キャンセルしました")
                        }
                        
                    }, message: {
                        Text("通信を切断すると、通信しているもう一方のユーザが、あなたに会いに来ることができなくなります。")
                    })
                    .navigationBarBackButtonHidden(true)
                } else {
                    Text("相手のデバイスと接続中です")
                }
            }
            .padding()
        }
    }
}
