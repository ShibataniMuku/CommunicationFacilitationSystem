import Foundation
import MultipeerConnectivity

class AvailableDevice {
    var id = UUID()
    var mcPeerId: MCPeerID
    var commonKeywords: [String]
    
    init(mcPeerId: MCPeerID, commonKeywords: [String]){
        self.id = UUID()
        self.mcPeerId = mcPeerId
        self.commonKeywords = commonKeywords
    }
}
