import Foundation

class ChecklistItem: NSObject, NSCoding {
    var checked = false
    var text = ""

    required init(coder aDecoder: NSCoder) {
        checked = aDecoder.decodeBoolForKey("Checked")
        text = aDecoder.decodeObjectForKey("Text") as! String
        super.init()
    }

    override init() {
        super.init()
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checked, forKey: "Checked")
    }

    func toggleChecked() {
        checked = !checked
    }

}
