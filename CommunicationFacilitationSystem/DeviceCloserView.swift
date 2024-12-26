import SwiftUI

struct DeviceCloserView: View {
    @ObservedObject var viewModel: ArrowViewModel
    @State private var isActiveCompleteMatchView: Bool = false
    
    var body: some View {
        NavigationLink(destination: ModeSelectView(),
                       isActive: $isActiveCompleteMatchView) {
                        EmptyView()
        }
        
        ZStack{
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            if let distance = viewModel.distance {
                if distance <= 0.2 {
                    CompleteMatchView()
                } else {
                    VStack(){
                        Text("デバイスを近づける")
                            .font(.largeTitle)
                            .bold()
                            .padding(.vertical)
                        Text("デバイス同士を近づけて、出会ったことを確定させましょう。")
                            .padding(.vertical)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .padding()
                }
            }
        }
    }
}
