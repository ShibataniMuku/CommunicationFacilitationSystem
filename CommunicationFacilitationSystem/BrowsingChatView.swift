//
//  BrowsingChatView.swift
//  MultipeerConnectivitySample
//
//  Created by makoto on 2021/02/19.
//

import SwiftUI
import MultipeerConnectivity

struct BrowsingChatView: View {
    @StateObject private var viewModel = BrowsingChatViewModel()

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.messages, id: \.self) { message in
                    Text(message)
                }
                .listStyle(PlainListStyle())
                
                Button(action: viewModel.sendMessage) {
                    Text("送信")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isSendEnabled ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .disabled(!viewModel.isSendEnabled)
            }
            .navigationBarTitle("Browsing Chat", displayMode: .inline)
            .navigationBarItems(
                trailing: Button("検索", action: viewModel.browse)
            )
            .onAppear {
                viewModel.startAdvertising()
            }
            .onDisappear {
                viewModel.stopAdvertising()
            }
        }
    }
}

//final class BrowsingChatViewModel: NSObject, ObservableObject {
//    @Published var messages: [String] = []
//    @Published var isSendEnabled = false
//
//    private let serviceType = "browsing-chat"
//    private var session: MCSession!
//    private var advertiser: MCNearbyServiceAdvertiser!
//    private var peerID: MCPeerID!
//    private var myKeywords = ["apple", "orange", "grape"]
//
//    override init() {
//        super.init()
//        setupMultipeerConnectivity()
//    }
//
//    func setupMultipeerConnectivity() {
//        peerID = MCPeerID(displayName: UIDevice.current.name)
//        session = MCSession(peer: peerID)
//        session.delegate = self
//
////        let randomKeyword = myKeywords.randomElement() ?? "default"
////        myKeywords = [randomKeyword]
//
//        let discoveryInfo = ["myKeywords": myKeywords.joined(separator: ",")]
//        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
//        advertiser.delegate = self
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
//            try session.send(message.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
//            addMessage(message)
//        } catch {
//            print("Send message failed: \(error.localizedDescription)")
//        }
//    }
//
//    func browse() {
//        let browserVC = MCBrowserViewController(serviceType: serviceType, session: session)
//        browserVC.delegate = self
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
//    // デバイスの接続状態が変化したときに呼び出される
//    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
//        let message: String
//        switch state {
//        case .connected:
//            message = "\(peerID.displayName)が接続されました"
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
//    // 他のデバイスからデータを受信したときに呼び出される
//    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        guard let message = String(data: data, encoding: .utf8) else { return }
//        addMessage(message)
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
//        // DiscoveryInfoからキーワード情報を取得
//        guard let discoveredKeywordsString = info?["myKeywords"] else {
//            return false
//        }
//        
//        // 発見したデバイスのキーワードを分割
//        let discoveredKeywords = discoveredKeywordsString.split(separator: ",")
//        
//        // 自分のキーワードと発見したキーワードの一致チェック
//        let commonKeywords = myKeywords.filter { discoveredKeywords.map(String.init).contains($0) }
//        
//        if !commonKeywords.isEmpty {
//            // 一致するキーワードがある場合のみリストに表示
//            print("一致キーワード: \(commonKeywords) - \(peerID.displayName)")
//            return true
//        } else {
//            // 一致するキーワードがない場合はリストに表示しない
//            print("キーワード不一致: \(peerID.displayName)")
//            return false
//        }
//    }
//}
