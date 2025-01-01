import Foundation
import SwiftData

class User {
    var id = UUID()
    var name: String
    var selfIntroduction: String
//    var photo: Image
    var mettedDay: Date
    var channel: String
    
    init(id: UUID = UUID(), name: String, selfIntroduction: String, mettedDay: Date, channel: String) {
        self.id = id
        self.name = name
        self.selfIntroduction = selfIntroduction
        self.mettedDay = mettedDay
        self.channel = channel
    }
}
