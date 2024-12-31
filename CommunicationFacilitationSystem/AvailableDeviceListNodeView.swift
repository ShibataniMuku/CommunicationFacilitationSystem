import SwiftUI

struct AvailableDeviceListNodeView: View {
    @State var availableDevice: AvailableDevice
    
    var body: some View {
        HStack{
            Text(availableDevice.mcPeerId.displayName)
                .foregroundColor(.black)
            Spacer()
            ForEach(availableDevice.commonKeywords, id: \.self){ commonKeyword in
                Text(commonKeyword)
                    .padding(5)
                    .background(
                        GeometryReader { geometry in
                            RoundedRectangle(cornerRadius: .infinity)
                                .fill(Color.orange)
                                .frame(width: geometry.size.width,
                                       height: geometry.size.height)
                        }
                    )
                    .foregroundColor(.white)
            }
        }
    }
}
