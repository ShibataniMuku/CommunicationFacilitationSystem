import SwiftUI
import MultipeerConnectivity
import NearbyInteraction

struct CommunicationView: View {
    @StateObject private var viewModel = ArrowViewModel()
    @State var communicationState: Communication = .searchingDevices
    @State var isShowDialog = false
    
    @State private var isFirst: Bool = true

    var body: some View {
        VStack {
            if viewModel.isConnectionRequested {
                if let distance = viewModel.distance {
                    if distance > 0.2 && isFirst {
                        FindedDeviceView(viewModel: viewModel)
                    } else {
                        CompleteMatchView()
                            .onAppear(){
                                isFirst = false
                            }
                    }
                }
            } else {
                switch communicationState {
                    case .searchingDevices: // 検索中
                        SearchDeviceView(viewModel: viewModel, communicationState: $communicationState)
                        
                    case .findingDevice: // 追跡中
                        if let distance = viewModel.distance {
                            if distance > 0.2 && isFirst {
                                FindingDeviceView(viewModel: viewModel)
                            } else {
                                CompleteMatchView()
                                    .onAppear(){
                                        isFirst = false
                                    }
                            }
                        }
                        
                    default:
                            EmptyView()
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
