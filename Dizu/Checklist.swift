import Foundation

class Checklist: NSObject, NSCoding {
    var items = [ChecklistItem]()
    var name = ""
    var icon: String

    init(name: String, icon: String) {
        self.name = name
        self.icon = icon
        super.init()
    }

    convenience init(name: String) {
        self.init(name: name, icon: "No Icon")
    }

    required init(coder aDecoder: NSCoder) {
        items = aDecoder.decodeObjectForKey("Items") as! [ChecklistItem]
        name  = aDecoder.decodeObjectForKey("Name")  as! String
        icon  = aDecoder.decodeObjectForKey("Icon")  as! String
        super.init()
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(items, forKey: "Items")
        aCoder.encodeObject(name,  forKey: "Name")
        aCoder.encodeObject(icon,  forKey: "Icon")
    }

    func countUncheckedItems() -> Int {
        var count = 0
        for item in items {
            if !item.checked {
                count += 1
            }
        }
        return count
    }
}
