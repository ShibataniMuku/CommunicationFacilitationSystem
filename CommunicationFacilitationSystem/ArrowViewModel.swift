import SwiftUI
import MultipeerConnectivity
import NearbyInteraction

final class ArrowViewModel: NSObject, ObservableObject {
    @Published var availablePeers: [MCPeerID] = []
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
    @AppStorage("MyName") var myName: String = ""
    @AppStorage("Channel") var myChannnel: String = ""
    private var peerID = MCPeerID(displayName: UIDevice.current.name)
    
    private var selectionValues: Array<String> = []
    private let myKeywords = ["apple", "orange", "grape"]

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

        let tokenData: Data
        do {
            tokenData = try NSKeyedArchiver.archivedData(withRootObject: myToken, requiringSecureCoding: true)
        } catch {
            print("トークンデータのシリアライズに失敗しました: \(error.localizedDescription)")
            return
        }

        if session.connectedPeers.contains(peer) {
            do {
                try session.send(tokenData, toPeers: [peer], with: .reliable)
                print("トークンを送信しました: \(peer.displayName)")
            } catch {
                print("トークン送信に失敗しました: \(error.localizedDescription)")
            }
        } else {
            print("\(peer.displayName)はまだ接続されていません")
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
                print("\(peerID.displayName)が接続されました")
                // 接続完了後にトークン送信可能
                do {
                    guard let tokenData = self.myTokenData else {
                        print("Error: myTokenData is nil.")
                        return
                    }
                    
                    try session.send(tokenData, toPeers: session.connectedPeers, with: .reliable)
                } catch {
                    print(error.localizedDescription)
                }
                
            case .connecting:
                if self.isAdvertiser{
                    self.isConnectionRequested = true
                }
                print("\(peerID.displayName)が接続中です")
            case .notConnected:
                print("\(peerID.displayName)が切断されました")
            @unknown default:
                print("\(peerID.displayName)が未知の状態です")
            }
        }
    }

    // 他のデバイスからデータを受信したときに呼びだされる
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            guard let discoveryToken = try NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data) else {
                print("トークンのデコードに失敗しました")
                return
            }

            // 受け取った相手のトークンをもとに，NearbyInteractionセッションを開始
            connectedPeerToken = discoveryToken
            if let token = connectedPeerToken {
                let config = NINearbyPeerConfiguration(peerToken: token)
                
                // 新しいセッションを開始する
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
            
            print("相手：\(channel), 自分：\(self.myChannnel)")
            
            if !commonKeywords.isEmpty && self.myChannnel == channel {
                self.availablePeers.append(peerID) // 見つけた端末リストに追加
            }
        }
    }

    // 発見した端末をロストしたときに呼ばれる
    func browser(_: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.availablePeers.removeAll { $0 == peerID }
        }
    }

    // 検索開始失敗時に呼ばれる
    func browser(_: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Failed to start browsing: \(error.localizedDescription)")
    }
}

// MARK: - NISessionDelegate
extension ArrowViewModel: NISessionDelegate {
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        guard let object = nearbyObjects.first else { return }
        DispatchQueue.main.async {
            self.distance = object.distance
            self.direction = object.__direction
        }
    }

    func sessionWasSuspended(_: NISession) {
        print("Nearby Interaction session suspended.")
    }

    func sessionSuspensionEnded(_: NISession) {
        print("Nearby Interaction session resumed.")
    }

    func session(_: NISession, didInvalidateWith error: Error) {
        print("Nearby Interaction session invalidated: \(error.localizedDescription)")
    }
}
