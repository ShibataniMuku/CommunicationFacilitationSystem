//
//  ModeSelectView.swift
//  CommunicationFacilitationSystem
//
//  Created by 柴谷 椋 on 2024/12/20.
//

import SwiftUI
import MultipeerConnectivity
import NearbyInteraction

struct ModeSelectView: View {
//    @StateObject private var viewModel = BrowsingChatViewModel()
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack{
                    Text("あなたと気が合う人を探しに出かけましょう")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding()
                    
                    List {
                        Section(header: Text("これまでに出会った人")) {
                            Text("aaaaa")
                        }
                    }
                    .navigationTitle("周囲を見わたす")
                    .scrollContentBackground(.hidden)
                    .environment(\.editMode, .constant(.active))
                                        
                    NavigationLink(destination: ArrowView()){
                        Text("周囲を見わたす")
                            .fontWeight(.medium)
                            .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
                                   height: UIScreen.main.bounds.size.width / 6 * 1)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(.infinity)
                    }
                    
//                    Button(action: viewModel.browse) {
//                        Text("探しに出かける")
//                            .fontWeight(.medium)
//                            .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
//                                   height: UIScreen.main.bounds.size.width / 6 * 1)
//                            .background(.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(.infinity)
//                    }
//                    .padding()
                }
//                .onAppear {
//                    viewModel.startAdvertising()
//                }
//                .onDisappear {
//                    viewModel.stopAdvertising()
//                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ModeSelectView()
}

//final class BrowsingChatViewModel: NSObject, ObservableObject {
//    @Published var messages: [String] = []
//    @Published var isSendEnabled = false
//    @State private var showingArrowView = false
//    
//    var niSession: NISession?
//    var myTokenData: Data?
//
//    private let serviceType = "browsing-chat"
//    private var session: MCSession!
//    private var advertiser: MCNearbyServiceAdvertiser!
//    private var peerID: MCPeerID!
//    private var myKeywords = ["apple", "orange", "grape"]
//    
//    private weak var browserVC: MCBrowserViewController? // MCBrowserViewControllerの参照を保持
//
//    override init() {
//        super.init()
//        setupMultipeerConnectivity()
//        setupNearbyInteraction()
//    }
//
//    func setupMultipeerConnectivity() {
//        peerID = MCPeerID(displayName: UIDevice.current.name) // デバイス検索時にリスト表示される自分の名前
//        session = MCSession(peer: peerID)
//        session.delegate = self
//
//        let discoveryInfo = ["myKeywords": myKeywords.joined(separator: ",")]
//        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
//        advertiser.delegate = self
//    }
//    
//    func setupNearbyInteraction() {
//        // Check if Nearby Interaction is supported.
//        guard NISession.isSupported else {
//            print("This device doesn't support Nearby Interaction.")
//            return
//        }
//        
//        // Set the NISession.
//        niSession = NISession()
////        niSession?.delegate = self
//        
//        // Create a token and change Data type.
//        guard let token = niSession?.discoveryToken else {
//            return
//        }
//        myTokenData = try! NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true)
//    }
//
//    func startAdvertising() {
//        advertiser.startAdvertisingPeer()
//    }
//
//    func stopAdvertising() {
//        advertiser.stopAdvertisingPeer()
//        session.disconnect()
//    }
//
//    func sendMessage() {
//        let message = "\(peerID.displayName)からのメッセージ"
//        do {
//            // 送信可能なデバイスがいる場合にトークンを送信
//            if !session.connectedPeers.isEmpty {
//                try session.send(myTokenData!, toPeers: session.connectedPeers, with: .reliable)
//                print("Discovery token sent successfully.")
//            } else {
//                print("No connected peers to send the token.")
//            }
//        } catch {
//            print("Failed to send discovery token: \(error.localizedDescription)")
//        }
//
//    }
//
//    func browse() {
//        let browserVC = MCBrowserViewController(serviceType: serviceType, session: session)
//        browserVC.delegate = self
//        self.browserVC = browserVC // インスタンスを保持
//        UIApplication.shared.windows.first?.rootViewController?.present(browserVC, animated: true)
//    }
//
//    private func addMessage(_ message: String) {
//        DispatchQueue.main.async {
//            self.messages.append(message)
//        }
//    }
//}
//
//extension BrowsingChatViewModel: MCSessionDelegate {
//    // デバイスの接続状況が変化したときに呼ばれる
//    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
//        let message: String
//        switch state {
//        case .connected:
//            print("接続されました")
//            message = "\(peerID.displayName)が接続されました"
//            
//            // メッセージを送信する
//            sendMessage()
//            
//            DispatchQueue.main.async {
//                // 接続されたデバイスが1台以上になったらブラウザを閉じる
//                if !session.connectedPeers.isEmpty {
//                    self.browserVC?.dismiss(animated: true)
//                    self.browserVC = nil // メモリリーク防止のため参照を解放
//                }
//            }
//        case .connecting:
//            message = "\(peerID.displayName)が接続中です"
//        case .notConnected:
//            message = "\(peerID.displayName)が切断されました"
//        @unknown default:
//            message = "\(peerID.displayName)が想定外の状態です"
//        }
//        addMessage(message)
//        DispatchQueue.main.async {
//            self.isSendEnabled = !self.session.connectedPeers.isEmpty
//        }
//    }
//
//    // データを受信したときに呼ばれる
//    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        print("データを受信しました")
//
//        guard let peerDiscoverToken = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data) else {
//            print("Failed to decode data.")
//            return }
//        
//        // 相手のデバイスからトークンが送られてきたら，矢印の画面へ遷移する
//        let partnerConfig = NINearbyPeerConfiguration(peerToken: peerDiscoverToken)
//        showingArrowView = true
//        NavigationLink(destination: ArrowView(config: partnerConfig, niSession: niSession), isActive: $showingArrowView) {
//            EmptyView()
//        }
//    }
//
//    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
//    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
//    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
//}
//
//extension BrowsingChatViewModel: MCNearbyServiceAdvertiserDelegate {
//    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
//        invitationHandler(true, session)
//    }
//
//    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
//        print("Failed to start advertising: \(error.localizedDescription)")
//    }
//}
//
//extension BrowsingChatViewModel: MCBrowserViewControllerDelegate {
//    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
//        browserViewController.dismiss(animated: true)
//    }
//
//    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
//        browserViewController.dismiss(animated: true)
//    }
//
//    func browserViewController(_ browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool {
//        guard let discoveredKeywordsString = info?["myKeywords"] else {
//            return false
//        }
//
//        let discoveredKeywords = discoveredKeywordsString.split(separator: ",")
//        let commonKeywords = myKeywords.filter { discoveredKeywords.map(String.init).contains($0) }
//
//        return !commonKeywords.isEmpty
//    }
//}
