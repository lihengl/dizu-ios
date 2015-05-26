import Foundation

class DataModel {
    class func nextChecklistItemID() -> Int {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let itemID = userDefaults.integerForKey("ChecklistItemID")
        userDefaults.setInteger(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }

    var lists = [Checklist]()
    var indexOfSelectedChecklist: Int {
        get {
            return NSUserDefaults.standardUserDefaults()
            .integerForKey("ChecklistIndex")
        }
        set {
            NSUserDefaults.standardUserDefaults()
            .setInteger(newValue, forKey: "ChecklistIndex")
        }
    }

    func registerDefaults() {
        let defaults = [
            "ChecklistItemID": 0,
            "ChecklistIndex": -1,
            "FirstTime": true
        ]
        NSUserDefaults.standardUserDefaults().registerDefaults(defaults)
    }

    func handleFirstTime() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTime = userDefaults.boolForKey("FirstTime")
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefaults.setBool(false, forKey: "FirstTime")
        }
    }

    func dataFilePath() -> String {
        let directories = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
        ) as! [String]
        return directories[0].stringByAppendingPathComponent("Checklists.plist")
    }

    func sortChecklists() {
        lists.sort({
            list1, list2 in return
            list1.name.localizedStandardCompare(list2.name) ==
            NSComparisonResult.OrderedAscending
        })
    }

    func loadChecklists() {
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                lists = unarchiver.decodeObjectForKey("Checklists")
                    as! [Checklist]
                unarchiver.finishDecoding()
                sortChecklists()
            }
        }
    }

    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }

    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }

}
