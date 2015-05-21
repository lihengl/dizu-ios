import UIKit

class ChecklistViewController: UITableViewController,
    ItemDetailViewControllerDelegate {
    var errorMessage = "UNEXPECTED ROW"
    var items: [ChecklistItem]

    required init(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()
        super.init(coder: aDecoder)
        loadChecklistItems()
    }

    func loadChecklistItems() {
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                items = unarchiver.decodeObjectForKey("ChecklistItems")
                    as! [ChecklistItem]
                unarchiver.finishDecoding()
            }
        }
    }

    func dataFilePath() -> String {
        let directories = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true
        ) as! [String]
        return directories[0].stringByAppendingPathComponent("Checklist.plist")
    }

    func saveChecklistItems() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }

    func configureCheckmarkForCell(cell: UITableViewCell,
        withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        label.text = item.checked ? "√" : ""
    }

    func configureTextForCell(cell: UITableViewCell,
        withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }

    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func itemDetailViewController(controller: ItemDetailViewController,
        didFinishAddingItem item: ChecklistItem) {
        items.append(item)
        let indexPath = NSIndexPath(forRow: (items.count - 1), inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath],
            withRowAnimation: .Automatic
        )
        dismissViewControllerAnimated(true, completion: nil)
        saveChecklistItems()
    }

    func itemDetailViewController(controller: ItemDetailViewController,
        didFinishEditingItem item: ChecklistItem) {
        if let index = find(items, item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                configureTextForCell(cell, withChecklistItem: item)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
        saveChecklistItems()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destinationViewController
                as! UINavigationController
            let controller = navigationController.topViewController
                as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destinationViewController
                as! UINavigationController
            let controller = navigationController.topViewController
                as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPathForCell(
                sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }

    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem")
            as! UITableViewCell
        let item = items[indexPath.row]

        configureCheckmarkForCell(cell, withChecklistItem: item)
        configureTextForCell(cell, withChecklistItem: item)

        return cell
    }

    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        saveChecklistItems()
    }

    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
        items.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath],
            withRowAnimation: .Automatic
        )
        saveChecklistItems()
    }

}

