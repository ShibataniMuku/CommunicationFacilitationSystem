import SwiftUI
import MultipeerConnectivity
import NearbyInteraction

struct ModeSelectView: View {
    @State var password: String = ""

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
                    
                    Form{
                        TextField("会場の合言葉", text: $password)
                    }
                    .navigationTitle("周囲を見わたす")
                                        
                    NavigationLink(destination: ArrowView()){
                        Button{
                            
                        } label: {
                            Text("散策に出かける")
                                .fontWeight(.medium)
                                .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
                                       height: 60)
                                .background(password != "" ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(.infinity)
                        }
                        .padding()
                        .disabled(password != "")
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ModeSelectView()
}
