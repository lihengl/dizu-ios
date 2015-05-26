import Foundation
import UIKit

class ChecklistItem: NSObject, NSCoding {
    var shouldRemind = false
    var dueDate = NSDate()
    var checked = false
    var itemID: Int
    var text = ""

    func toggleChecked() {
        checked = !checked
    }

    func notificationForThisItem() -> UILocalNotification? {
        let sharedApplication = UIApplication.sharedApplication()
        let allNotifications = sharedApplication.scheduledLocalNotifications
            as! [UILocalNotification]

        for notification in allNotifications {
            if let number = notification.userInfo?["ItemID"] as? NSNumber {
                if number.integerValue == itemID {
                    return notification
                }
            }
        }

        return nil
    }

    func scheduleNotification() {
        let sharedApplication = UIApplication.sharedApplication()
        let existingNotification = notificationForThisItem()

        if let notification = existingNotification {
            sharedApplication.cancelLocalNotification(notification)
        }

        if shouldRemind && (dueDate.compare(NSDate()) !=
            NSComparisonResult.OrderedAscending) {
            let localNotification = UILocalNotification()
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.alertBody = text
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.fireDate = dueDate
            localNotification.userInfo = ["ItemID": itemID]

            sharedApplication.scheduleLocalNotification(localNotification)
        }
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(itemID, forKey: "ItemID")
        aCoder.encodeObject(dueDate, forKey: "DueDate")
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(shouldRemind, forKey: "ShouldRemind")
        aCoder.encodeBool(checked, forKey: "Checked")
    }

    required init(coder aDecoder: NSCoder) {
        shouldRemind = aDecoder.decodeBoolForKey("ShouldRemind")
        dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
        checked = aDecoder.decodeBoolForKey("Checked")
        itemID = aDecoder.decodeIntegerForKey("ItemID")
        text = aDecoder.decodeObjectForKey("Text") as! String
        super.init()
    }

    override init() {
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }

    deinit {
        let sharedApplication = UIApplication.sharedApplication()
        let existingNotification = notificationForThisItem()
        if let notification = existingNotification {
            sharedApplication.cancelLocalNotification(notification)
        }
    }

}
