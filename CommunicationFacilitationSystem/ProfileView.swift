import SwiftUI

struct ProfileView: View {
    @AppStorage("MyName") var name: String = ""
    @AppStorage("MySex") var sex: Sex = .noAnswer
    @AppStorage("MyBirthday") var birthday: Date = Date()
    @AppStorage("Birthplace") var birthplace: Prefecture = .noAnswer
    @AppStorage("Residence") var residence: Prefecture = .noAnswer
    
    var body: some View {
        ZStack{
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            NavigationView{
                List{
                    Section(header: Text("基本情報")) {
                        TextField("ニックネーム", text: $name)
                        Picker("性別", selection: $sex){
                            Text(Sex.male.rawValue).tag(Sex.male)
                            Text(Sex.female.rawValue).tag(Sex.female)
                            Text(Sex.other.rawValue).tag(Sex.other)
                            Text(Sex.noAnswer.rawValue).tag(Sex.noAnswer)
                        }
                        .pickerStyle(.navigationLink)
                        
                        DatePicker("誕生日", selection: $birthday, displayedComponents: [.date])
                        
                        Picker("出身地", selection: $birthplace){
                            ForEach(Prefecture.allCases, id: \.id) { prefecture in
                                Text(prefecture.rawValue)
                            }
                        }
                        .pickerStyle(.navigationLink)
                        
                        Picker("居住地", selection: $residence){
                            ForEach(Prefecture.allCases, id: \.id) { prefecture in
                                Text(prefecture.rawValue)
                            }
                        }
                        .pickerStyle(.navigationLink)
                    }
                    
                    Section(header: Text("詳細情報")) {
                        TextField("自己紹介", text: $name, axis: .vertical)
                            .frame(height: 100, alignment: .top)
                    }
                    
                    Section(header: Text("キーワード")) {
                        NavigationLink(destination: RegisteringKeywordView()) {
                            Text("キーワード")
                        }
                    }
                }
                .navigationTitle("プロフィール")
            }
        }
    }
}

#Preview {
    ProfileView()
}
