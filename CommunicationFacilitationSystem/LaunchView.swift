import SwiftUI

struct LaunchView: View {
    @AppStorage("MyName") var myName: String = ""
    
    var body: some View {
        NavigationView{
            ZStack{
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack{
                    Spacer()
                    
                    NavigationLink(destination: RegisteringMyNameSetupView()){
                        Button{
                             
                        } label: {
                            Text("新しくはじめる")
                                .fontWeight(.medium)
                                .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
                                       height: 60)
                                .background(.blue)
                                .foregroundColor(.white)
                                .cornerRadius(.infinity)
                        }
                        .disabled(true)
                    }
                    
                    NavigationLink(destination: ModeSelectView()){
                        Button{
                            
                        } label: {
                            Text("前回と同じ設定ではじめる")
                                .fontWeight(.medium)
                                .frame(width: UIScreen.main.bounds.size.width / 6 * 4,
                                       height: 60)
                                .background(.blue)
                                .foregroundColor(.white)
                                .cornerRadius(.infinity)
                        }
                        .disabled(true)
                    }
                }
            }
        }
    }
}

#Preview {
    LaunchView()
}
