import Foundation

class Checklist: NSObject, NSCoding {
    var name = ""
    var items = [ChecklistItem]()

    init(name: String) {
        self.name = name
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        items = aDecoder.decodeObjectForKey("Items") as! [ChecklistItem]
        name  = aDecoder.decodeObjectForKey("Name")  as! String
        super.init()
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(items, forKey: "Items")
        aCoder.encodeObject(name, forKey: "Name")
    }
}
