import SwiftUI

struct FindingDeviceView: View {
    @ObservedObject var viewModel: ArrowViewModel
    @State var isActiveModeSelectView: Bool = false
    
    @State private var isShowDialog = false

    var meetingDistance: Float = 1.0
    
    var body: some View {
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
                        Text("デバイス同士を近づけてください")
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
                    
                    DisconnectButton(viewModel: viewModel)
                }
                .padding()
            } else {
                HStack{
                    ProgressView("相手のデバイスと接続中です")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
