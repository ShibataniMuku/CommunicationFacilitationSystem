import SwiftUI
import MultipeerConnectivity
import NearbyInteraction

final class ArrowViewModel: NSObject, ObservableObject {
    @Published var availableDevices: [AvailableDevice] = []
    @Published var distance: Float?
    @Published var direction: simd_float3?
    @Published var isConnectionRequested = false; // 接続を要求された
    @Published var isAdvertiser = false; // 接続を要求される側

    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser!
    private var browser: MCNearbyServiceBrowser!
    private var niSession: NISession?
    private var connectedPeerToken: NIDiscoveryToken?
    
    var myTokenData: Data?
    
    private let serviceType = "browsing-chat"
    private let userDefaultsKey = "SelectedKeywords"
    @AppStorage("MyName") var myName: String = ""
    @AppStorage("Channel") var myChannnel: String = ""
    private var peerID = MCPeerID(displayName: UIDevice.current.name)
    
    private var selectionValues: Array<String> = []
    private var myKeywords: [String] = []

    override init() {
        super.init()
        peerID = MCPeerID(displayName: myName)
        setupMultipeerConnectivity()
        setupNearbyInteraction()
    }

    // Multipeer Connectivity のセットアップ
    func setupMultipeerConnectivity() {
        session = MCSession(peer: peerID)
        session.delegate = self
        
        // キーワードの登録
        if let myKeywords = UserDefaults.standard.array(forKey: userDefaultsKey) as? [String]{
            self.myKeywords = myKeywords
        }
        let discoveryInfo = ["myKeywords": myKeywords.joined(separator: ","), "channel": myChannnel]
        
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()

        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        browser.delegate = self
    }

    // Nearby Interaction のセットアップ
    func setupNearbyInteraction() {
        guard NISession.isSupported else {
            print("This device doesn't support Nearby Interaction.")
            return
        }

        niSession = NISession()
        niSession?.delegate = self
        
        // Create a token and change Data type.
        guard let token = niSession?.discoveryToken else {
            return
        }
        myTokenData = try! NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true)
    }
    
    // NearbyInteractionを停止する
    func stopSession(){
        niSession?.invalidate()
        print("NIのセッションを停止しました")
    }

    // 周辺のユーザの探索開始
    func startBrowsing() {
        print("ブラウズ開始")
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }

    // 周辺のユーザの探索停止
    func stopBrowsing() {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
        session.disconnect()
    }

    // デバイスに接続
    func connectToPeer(_ peer: MCPeerID) {
        print("デバイスに接続")
        guard let myToken = niSession?.discoveryToken else {
            print("Nearby Interactionのトークンが取得できません")
            return
        }
        
        browser.invitePeer(peer, to: session, withContext: nil, timeout: 0) // 接続を招待（要求）する
    }
    
    // トークンを送信する
    func sendToken(peer peerID: MCPeerID){
        do {
            guard let myToken = self.niSession?.discoveryToken else {
                print("Nearby Interactionのトークンが取得できません")
                return
            }
            
            guard var tokenData = self.myTokenData else {
                print("Error: myTokenData is nil.")
                return
            }
            
            do {
                tokenData = try NSKeyedArchiver.archivedData(withRootObject: myToken, requiringSecureCoding: true)
            } catch {
                print("トークンデータのシリアライズに失敗しました: \(error.localizedDescription)")
                return
            }

            guard session.connectedPeers.contains(peerID) else {
                print("\(peerID.displayName)はまだ接続されていません")
                return
            }

            let tokenMessage = ["type": "discoveryToken", "data": tokenData.base64EncodedString()]
                                
            do {
                let messageData = try JSONSerialization.data(withJSONObject: tokenMessage, options: [])
                try session.send(messageData, toPeers: [peerID], with: .reliable)
                print("トークンを送信しました: \(peerID.displayName)")
            } catch {
                print("トークン送信に失敗しました: \(error.localizedDescription)")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // ボタン押下を通知する
    func sendButtonPress(to peer: MCPeerID, _ buttonName: String) {
        guard session.connectedPeers.contains(peer) else {
            print("\(peer.displayName)はまだ接続されていません")
            return
        }

        let buttonPressMessage = ["type": "buttonPress", "buttonName": buttonName]
        do {
            let messageData = try JSONSerialization.data(withJSONObject: buttonPressMessage, options: [])
            try session.send(messageData, toPeers: [peer], with: .reliable)
            print("ボタン押下通知を送信しました: \(peer.displayName)")
        } catch {
            print("ボタン押下通知の送信に失敗しました: \(error.localizedDescription)")
        }
    }
    
    // メッセージを送信する
    func sendMessage(to peer: MCPeerID, _ message: String) {
        guard session.connectedPeers.contains(peer) else {
            print("\(peer.displayName)はまだ接続されていません")
            return
        }

        let textMessage = ["type": "textMessage", "message": message]
        do {
            let messageData = try JSONSerialization.data(withJSONObject: textMessage, options: [])
            try session.send(messageData, toPeers: [peer], with: .reliable)
            print("メッセージを送信しました: \(peer.displayName)")
        } catch {
            print("メッセージ送信に失敗しました: \(error.localizedDescription)")
        }
    }
}

// MARK: - MCSessionDelegate
extension ArrowViewModel: MCSessionDelegate {
    // デバイスの接続状況が変化したときに呼び出される
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .connected:
                print("\(peerID.displayName)のMCが接続されました")
                // 接続完了後にトークンを送信
                self.sendToken(peer: peerID)
            case .connecting:
                if self.isAdvertiser{
                    self.isConnectionRequested = true
                }
                print("\(peerID.displayName)のMCが接続中です")
            case .notConnected:
                print("\(peerID.displayName)のMCが切断されました")
            @unknown default:
                print("\(peerID.displayName)のMCが未知の状態です")
            }
        }
    }

    // 他のデバイスからデータを受信したときに呼びだされる
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            guard let message = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let messageType = message["type"] as? String else {
                print("受信データの解析に失敗しました")
                return
            }
            
            print(messageType)

            switch messageType {
                case "discoveryToken":
                print("NIのトークンを受信しました: \(peerID.displayName)")
                    if let base64EncodedData = message["data"] as? String,
                       let tokenData = Data(base64Encoded: base64EncodedData) {
                        handleTokenData(tokenData, from: peerID)
                    }
                    
                case "buttonPress":
                    if let receivedButtonName = message["buttonName"] as? String {
                        print("メッセージを受信しました: \(receivedButtonName)")
                        handleMessage(from: peerID, receivedButtonName)
                    }
                
                case "textMessage":
                    if let receivedMessage = message["message"] as? String {
                        print("メッセージを受信しました: \(receivedMessage)")
                        handleMessage(from: peerID, receivedMessage)
                    }

                default:
                    print("未知のメッセージタイプを受信しました: \(messageType)")
            }
        } catch {
            print("受信データの解析に失敗しました: \(error.localizedDescription)")
        }
    }
    
    func handleTokenData(_ data: Data, from peerID: MCPeerID) {
        do {
            guard let discoveryToken = try NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data) else {
                print("トークンのデコードに失敗しました")
                return
            }

            // NearbyInteractionのセッションを開始
            connectedPeerToken = discoveryToken
            if let token = connectedPeerToken {
                let config = NINearbyPeerConfiguration(peerToken: token)
                config.isCameraAssistanceEnabled = true
                
                if niSession == nil {
                    setupNearbyInteraction()
                }
                
                niSession?.run(config)
                print("Nearby Interactionセッションを開始しました")
            }
        } catch {
            print("トークンデータの復元に失敗しました: \(error.localizedDescription)")
        }
    }

    func handleButtonPress(from peer: MCPeerID, _ message: String) {
        // ボタン押下通知の処理
        print("ボタンが押されました: \(peer.displayName)")
    }

    func handleMessage(from peer: MCPeerID, _ message: String) {
        // メッセージ受信の処理
        print("受信したメッセージ: \(message) from \(peer.displayName)")
    }


    func session(_: MCSession, didReceive _: InputStream, withName _: String, fromPeer _: MCPeerID) {}
    func session(_: MCSession, didStartReceivingResourceWithName _: String, fromPeer _: MCPeerID, with _: Progress) {}
    func session(_: MCSession, didFinishReceivingResourceWithName _: String, fromPeer _: MCPeerID, at _: URL?, withError _: Error?) {}
}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension ArrowViewModel: MCNearbyServiceAdvertiserDelegate {
    // 検索され接続を要求されたときに呼び出される
    func advertiser(_: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext _: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("接続を要求されました: \(peerID.displayName)")
        invitationHandler(true, session)
        self.isAdvertiser = true
    }
}

// MARK: - MCNearbyServiceBrowserDelegate
// 細かい設定がいらない場合は MCBrowserViewController を使う方が楽。
extension ArrowViewModel: MCNearbyServiceBrowserDelegate {
    // 端末を発見した時に呼ばれる
    func browser(_: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        print("端末を発見した: \(peerID.displayName)")
                
        DispatchQueue.main.async {
            guard let keywords = info?["myKeywords"]?.split(separator: ",").map(String.init) else { return }
            guard let channel = info?["channel"] else { return }

            let commonKeywords = self.myKeywords.filter { keywords.contains($0) }
            
            print("相手：\(keywords), 自分：\(self.myKeywords), 共通：\(commonKeywords)")
            
            if !commonKeywords.isEmpty && self.myChannnel == channel {
//                self.availablePeers.append(peerID) // 見つけた端末リストに追加
                self.availableDevices.append(AvailableDevice(mcPeerId: peerID, commonKeywords: commonKeywords))
            }
        }
    }

    // 発見した端末をロストしたときに呼ばれる
    func browser(_: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.availableDevices.removeAll { $0.mcPeerId == peerID }
        }
    }

    // 検索開始失敗時に呼ばれる
    func browser(_: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Failed to start browsing: \(error.localizedDescription)")
    }
}

// MARK: - NISessionDelegate
extension ArrowViewModel: NISessionDelegate {
    // NIが近傍オブジェクトを更新した時に呼ばれる
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        guard let object = nearbyObjects.first else { return }
        
        DispatchQueue.main.async {
            self.distance = object.distance
            self.direction = object.direction
        }
    }
    
    func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason){
        print("セッションが，1つ以上の近傍オブジェクトを削除しました")
    }

    // NIが中断された時に呼ばれる
    func sessionWasSuspended(_: NISession) {
        print("Nearby Interaction session suspended.")
    }

    // NIが再開された時に呼ばれる
    func sessionSuspensionEnded(_: NISession) {
        print("Nearby Interaction session resumed.")
    }

    // NIが終了した時に呼ばれる
    func session(_: NISession, didInvalidateWith error: Error) {
        print("Nearby Interaction session invalidated: \(error.localizedDescription)")
    }
}
