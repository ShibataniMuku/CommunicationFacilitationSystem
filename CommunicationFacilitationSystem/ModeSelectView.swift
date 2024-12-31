import SwiftUI
import MultipeerConnectivity
import NearbyInteraction

struct ModeSelectView: View {
    @AppStorage("Channel") var myChannnel: String = ""

    var body: some View {
        NavigationView{
            ZStack{
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(){
                    Text("周囲を見わたす")
                        .font(.largeTitle)
                        .bold()
                        .padding(.vertical)
                    Text("あなたと気が合う人を探しに出かけましょう")
                        .padding(.vertical)
                        .multilineTextAlignment(.center)
                    
                    Form{
                        TextField("会場の合言葉", text: $myChannnel)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: ArrowView()){
                        Button{
                            
                        } label: {
                            Text("散策に出かける")
                                .fontWeight(.medium)
                                .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
                                       height: 60)
                                .background(myChannnel != "" ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(.infinity)
                        }
                        .padding()
                        .disabled(myChannnel != "")
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
