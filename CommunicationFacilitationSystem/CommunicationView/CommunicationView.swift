import SwiftUI
import MultipeerConnectivity
import NearbyInteraction

struct CommunicationView: View {
    @StateObject private var viewModel = ArrowViewModel()
    @State var communicationState: Communication = .searchingDevices
    @State var isShowDialog = false

    var body: some View {
        VStack {
            if viewModel.isConnectionRequested{
                if let distance = viewModel.distance {
                    if distance > 0.2 {
                        FindedDeviceView(viewModel: viewModel)
                    } else {
                        CompleteMatchView()
                    }
                }
            } else {
                switch communicationState {
                    case .searchingDevices: // 検索中
                        SearchDeviceView(viewModel: viewModel, communicationState: $communicationState)
                        
                    case .findingDevice: // 追跡中
                        if let distance = viewModel.distance {
                            if distance > 0.2 {
                                FindingDeviceView(viewModel: viewModel)
                            } else {
                                CompleteMatchView()
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
