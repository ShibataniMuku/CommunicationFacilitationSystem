import SwiftUI
import NearbyInteraction

struct ArrowView: View {
    let config: NSObject
    let niSession: NISession?

    @StateObject private var viewModel = NearbyInteractionViewModel()

    var body: some View {
        VStack {
            if let distance = viewModel.distance {
                Text("距離: \(distance) m")
                    .font(.title)
            } else {
                Text("距離: 計測中")
                    .font(.title)
            }

            if let direction = viewModel.direction {
                VStack {
                    Text("方向 X: \(direction.x)")
                    Text("方向 Y: \(direction.y)")
                    Text("方向 Z: \(direction.z)")
                }
                .font(.headline)
            } else {
                Text("方向: 計測中")
                    .font(.headline)
            }
        }
        .onAppear {
            viewModel.startSession(with: config, niSession: niSession)
        }
    }
}

final class NearbyInteractionViewModel: NSObject, ObservableObject, NISessionDelegate {
    @Published var distance: Float?
    @Published var direction: simd_float3?

    func startSession(with config: NSObject, niSession: NISession?) {
        guard let config = config as? NINearbyAccessoryConfiguration else {
            print("Invalid configuration type")
            return
        }

        niSession?.run(config)
    }

    // MARK: - NISessionDelegate Methods

    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        guard let accessory = nearbyObjects.first else { return }
        var stringData = ""

        if let distance = accessory.distance {
            DispatchQueue.main.async {
                self.distance = distance
            }
            stringData += "\(distance)"
        } else {
            DispatchQueue.main.async {
                self.distance = nil
            }
            stringData += "-"
        }
        stringData += ","

        if let direction = accessory.direction {
            DispatchQueue.main.async {
                self.direction = direction
            }
            stringData += "\(direction.x),\(direction.y),\(direction.z)"
        } else {
            DispatchQueue.main.async {
                self.direction = nil
            }
            stringData += "-,-,-"
        }
        stringData += "\n"
    }

    func sessionWasSuspended(_ session: NISession) {
        print("セッションが一時停止されました")
    }

    func sessionSuspensionEnded(_ session: NISession) {
        print("セッションが再開されました")
    }

    func session(_ session: NISession, didInvalidateWith error: Error) {
        print("セッションが無効になりました: \(error.localizedDescription)")
    }
}
