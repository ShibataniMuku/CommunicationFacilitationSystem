import SwiftUI

struct FindedDeviceView: View {
    @ObservedObject var viewModel: ArrowViewModel
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
                    Text("あなたを探しています")
                        .font(.largeTitle)
                        .bold()
                        .padding(.vertical)
                    Text("あなたの周辺にいるユーザが、あなたを探しています。\n近くに来たら、話しかけてみましょう。")
                        .padding(.vertical)
                        .multilineTextAlignment(.center)
                    Spacer()
                    
                    DisconnectButton(viewModel: viewModel)
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
