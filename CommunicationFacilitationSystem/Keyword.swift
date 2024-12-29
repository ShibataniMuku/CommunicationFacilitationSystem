import Foundation
import SwiftData

@Model
class KeywordGroup {
    var id = UUID()
    var groupName: String
    var keywords: [Keyword]
    
    init(groupName: String, keywords: [Keyword]){
        self.groupName = groupName
        self.keywords = keywords
    }
}

@Model
class Keyword {
    var id: UUID
    var name: String
    var isSelected: Bool = false

    init(name: String, isSelected: Bool = false) {
        self.id = UUID()
        self.name = name
        self.isSelected = isSelected
    }
}
